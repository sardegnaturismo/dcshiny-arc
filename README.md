# SHINYDASHBOARD

## Obiettivo
Realizzare una dashboard di distribuzione dei contenuti (dati su file csv) elaborati mediante shiny ed erogati   mediante l'uso dell'application server shiny-server.

## Descrizione servizio
L'erogazione è organizzata in 3 elementi (docker container):
1. Frontend proxy (modulo nginx)   
2. Application server (modulo shiny-server)
3. File Sync Worker (modulo worker)

### 1. Frontend proxy (modulo nginx)
Implementa il servizio di http proxy verso l'application server (di seguito), link di upstream: http://shiny-server:3838
Implementa inoltre l'inject di codice javascript sostituendo il tag html '</head>' nelle risposte.

### 2. Application server (modulo shiny-server)
Eroga shiny-server eseguendo la build del container a partire da ubuntu:16.04 
Il codice dell'applicazione Shiny-server viene copiato all'interno del container, i dati (file csv) vengono caricati all'avvio del servizio dal volume EFS connesso al Cluster ECS.

### 3. File Sync Worker (modulo worker)
I file csv usati come orgine per la dashboard vengono processati e caricati su S3://datalake.sardegnaturismocloud.it/prod/dashboard_operatore/source_files/ (estensione .csv).
L'infrastruttura esegue la copia dei file da s3 al mountpoint per il cluster ECS di destinazione in tre passaggi:
1. L'evento "ObjectCreate (All)" configurato per il path sul bucket S3 genera un messaggio ad ogni nuovo caricamento con i riferimenti dell'oggetto creato (include il filename). 
2. Il messaggio viene caricato sulla coda SQS dedicata {ambiente}-shinydash-worker
3. Lo script bash caricato sul modulo worker verifica periodicamente la presenza di nuovi messaggi sulla coda. Ad ogni nuovo caricamento sul bucket il primo worker che legge il messaggio lo prende in carico, esegue la copia sul volume EFS connesso al cluster ECS e lo segna come completato (eliminandolo dalla coda).
L'implementazione garantisce l'isolamento, l'alta affidabilità e la scalabilità delle risorse (è sufficiente incrementare il numero di moduli worker per aumentare i processi simultanei di copia da S3 a EFS)  

## Continous Delivery
L'implementazione di nuove funzionalità, la correzione di bug sull'infrastruttura (aws e definizione container) o l'aggiornamento del codice shiny-server può procedere con workflow di rilascio continuo sfruttando ambienti multipli (test/dev, stage e prod).
Segue descrizione per ognuno.

### Test/Dev 
È implementato con l'uso di docker-compose (avvia solo proxy e application server) su cui vanno però caricati i dati di test.

### Stage
È identico a "Prod" ad esclusione del numero di istanze ridotte per il cluster ECS (1 invece di 2) e del processo di caricamento dei file csv semplificato (caricamento simultaneo post-build)
L'ambiente è compatibile con i meccanismi di ottimizzazione delle risorse per l'on/off programmato o a richiesta (via API)

### Prod
Esegue tutti i moduli in alta affidabilità (service ridondati)


## Build e push manuale delle immagini
Per aggiornare manualmente le immagini dei container sui registri ECR per gli ambienti stage e prod sono disponibili gli script bash di seguito illustrati. 

Es. Esecuzione su istanza EC2 dedicata al build "docker-factory" su account RAS: 
```
# Build e push <ambiente> = stage | prod 
git clone <this git repo url>
cd Docker
sh update.sh # application code update)
sh build.sh -e <ambiente> #  build/tag/push to ecr registry
```



## Infrastruttura di riferimento per ECS


Include i moduli:
1. ECS Cluster
2. Service
3. Load Balancer 
4. DeploymentPipeline
5. Definizione dei container
6. Codifica delle risorse infrastrutturali

1. ECS Cluster
Insieme di 1 o più EC2 istanze che eseguono Amazon ECS-optimized AMI. Il cluster condivide i dati tra le istanze usando un mountpoint EFS (Elastic File System)  nfsv4.

2. Service
È la definizione del task (composizione di docker e configurazioni del contesto) unito alle impostazioni di esecuzione del service sul cluster ECS (numero, IAM role ECR registry). Il service è usato come template per i processi di continous delivery

3. Load Balancer
L'Application Load Balancer (ALB) usato per ricever il traffico convogliato verso il servizio (attivo sull'ECS Cluster). In caso di ALB condiviso tra gli ambienti o i progetti, il setup prevede sempre il Target Group afferente al servizio.

4. DeploymentPipeline
Elenco degli step e delle risorse che compongono il processo di rilascio degli aggiornamenti periodici di codice applicativo per il servizio.
Include un progetto CodeBuild che costruisce l'immagine del container a partire dal codice sul repo git, il rilascio sul cluster ECS, la sequenza CodePipeline che esegue step-by-step i passaggi, un bucket S3 per la memorizzazione dei file temporanei e tutti i role IAM necessari per l'accesso alle risorse coinvolte.

5. Definizione dei container
Raccolta dei file di configurazione dei container (Dockerfile) e dei servizi erogati. Include un file bash per il build dei container e l'upload delle immagini generate suil servizio ECR del cluster ECS di destinazione.
Il file buildspec.yml (specifico per ogni container) definisce la sequenza di build e push su ECR ad uso del progetto CodeBuild relativo

6. Codifica delle risorse infrastrutturali
Tutte le risorse necessarie all'erogazione del servizio sono state configurate usando Terraform come strumento di provisioning


## Nomenclatura Generale

{ambiente}-{progetto}-{funzione}-{servizio}

ambiente = dev | stage | prod
progetto = nome sintetico che richiama il progetto di riferimento
funzione = ruolo o componente all'interno del progetto
servizio = sigla relativa al servizio AWS impiegato


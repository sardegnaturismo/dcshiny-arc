--==BOUNDARY==
Content-Type: text/text/x-shellscript; charset="us-ascii"

# Install nfs-utils
yum_update yum update -y
yum install -y nfs-utils

# Create /efs folder
mkdir /efs

# Mount /efs
echo -e "${efs_id}.efs.${region}.amazonaws.com:/ /efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
mount -a

# # Install ssm agent
# cd /tmp
# sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
# sudo start amazon-ssm-agent

--==BOUNDARY==
Content-Type: text/text/x-shellscript; charset="us-ascii"

#!/bin/bash

#
# This script generates config to be used by their respective Task Definitions:
# 1. consul-registrator startup script
# 2. Consul Agent config

# Gather metadata for linkerd and Consul Agent

EC2_INSTANCE_IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F: '{print $4}')
#
# Generate consul-registrator startup file
#

mkdir -p /opt/consul-registrator/bin

cat << EOF > /opt/consul-registrator/bin/start.sh
#!/bin/sh
exec /bin/registrator -ip $EC2_INSTANCE_IP_ADDRESS -retry-attempts -1 consul://$EC2_INSTANCE_IP_ADDRESS:8500
EOF

chmod a+x /opt/consul-registrator/bin/start.sh

#
# Generate Consul Agent config file
#

mkdir -p /opt/consul/data
mkdir -p /opt/consul/config

cat << EOF > /opt/consul/config/consul-agent.json
{
  "advertise_addr": "$EC2_INSTANCE_IP_ADDRESS",
  "client_addr": "0.0.0.0",
  "node_name": "${EC2_INSTANCE_ID}",
  "datacenter": "$REGION",
  "retry_join": ["provider=aws region=$REGION tag_key=consul-servers tag_value=auto-join"]
}
EOF

--==BOUNDARY==
Content-Type: text/text/upstart-job; charset="us-ascii"

#upstart-job
description "Amazon EC2 Container Service (start task on instance boot)"
author "Amazon Web Services"
start on started ecs

script
  exec 2>>/var/log/ecs/ecs-start-task.log
  set -x

  until curl -s http://localhost:51678/v1/metadata
  do
    sleep 1
  done

  instance_arn=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -vim F/ '{print $NF}' )
  cluster=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .Cluster' | awk -F/ '{print $NF}' )
  region=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F: '{print $4}')

  aws ecs start-task --cluster $cluster --task-definition consul-agent --container-instances $instance_arn --started-by $instance_arn --region $region
  aws ecs start-task --cluster $cluster --task-definition consul-registrator --container-instances $instance_arn --started-by $instance_arn --region $region
end script
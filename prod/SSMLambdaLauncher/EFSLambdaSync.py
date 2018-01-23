import boto3
import time
import json
 #The lambda_handler Python function gets called when you run your AWS Lambda function.
def lambda_handler(event, context):
 
    ssmClient = boto3.client('ssm')
    s3Client = boto3.client('s3')
 
    instanceId = event['id']
    bucket = event['bucket']
    keyPrefix = event['keyPrefix']
 
    ssmCommand = ssmClient.send_command(
        InstanceIds = [
            instanceId
        ],
        DocumentName = 'AWS-RunPowerShellScript',
        TimeoutSeconds = 240,
        Comment = 'Run Pester Tests',
        Parameters = {
            'commands': [
                &quot;cd C:/tests&quot;,
                 &quot;Invoke-Pester -OutputFile test.xml -OutputFormat NUnitXml&quot;,
                 &quot;aws s3 cp test.xml s3://&quot; + bucket + &quot;/&quot; + keyPrefix + &quot;/test.xml&quot;
            ]
        },
        OutputS3BucketName = bucket,
        OutputS3KeyPrefix = keyPrefix
    )
#poll SSM until EC2 Run Command completes
    status = 'Pending'
    while status == 'Pending' or status == 'InProgress':
        time.sleep(3)
        status = (ssmClient.list_commands(CommandId=ssmCommand['Command']['CommandId']))['Commands'][0]['Status']
 
    if(status != 'Success'):
        print &quot;test failed with status &quot; + status
        return
 
    xmlOutput = s3Client.get_object(
        Bucket = bucket,
        Key = keyPrefix + &quot;/test.xml&quot;
    )['Body'].read()
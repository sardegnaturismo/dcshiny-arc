#!/bin/bash

# Copyright 2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file.
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#
# Simple POV-Ray worker shell script.
#
# Uses the AWS CLI utility to fetch a message from SQS, fetch a ZIP file from S3 that was specified in the message,
# render its contents with POV-Ray, then upload the resulting .png file to the same S3 bucket.
#

region=${AWS_REGION}
queue=${SQS_QUEUE_URL}
short_polling=${SHORT_POLLING}
long_polling=${LONG_POLLING}

container_dest_path=${CONTAINER_DEST_PATH}

# Fetch messages and render them until the queue is drained.
while [ /bin/true ]; do
    # Fetch the next message and extract the S3 URL to fetch the POV-Ray source ZIP from.
    echo "Fetching messages fom SQS queue: ${queue}..."
    result=$( \
        aws sqs receive-message \
            --queue-url ${queue} \
            --region ${region} \
            --wait-time-seconds ${short_polling} \
            --query Messages[0].[Body,ReceiptHandle] \
        | sed -e 's/^"\(.*\)"$/\1/'\
    )
    receipt_handle=$(echo ${result} | sed -e 's/^.*"\([^"]*\)"\s*\]$/\1/')
    echo "Preloaded Receipt handle: ${receipt_handle}."

    if [ -z "${result}" ]; then
        echo "No messages left in queue. Long Polling Started"
        sleep ${long_polling}
      #  exit 0
    elif [ "${receipt_handle}" == "null" ]; then
        echo "Null received - no messages left in queue. Long Polling Started"
        sleep ${long_polling}
    else
        echo "Message: ${result}."

        receipt_handle=$(echo ${result} | sed -e 's/^.*"\([^"]*\)"\s*\]$/\1/')
        echo "Receipt handle: ${receipt_handle}."

        bucket=$(echo ${result} | sed -e 's/^.*arn:aws:s3:::\([^\\]*\)\\".*$/\1/')
        echo "Bucket: ${bucket}."

        key=$(echo ${result} | sed -e 's/^.*\\"key\\":\s*\\"\([^\\]*\)\\".*$/\1/')
        echo "Key: ${key}."

        base=${key%.*}
        ext=${key##*.}


#-a \
            # -n "${base}" -a \
            # -n "${ext}" -a \
            # "${ext}" = "csv" \
        if [ -n "${result}" -a \
            -n "${receipt_handle}" -a \
            -n "${key}"  ]; then
            # mkdir -p work
            #pushd ${container_dest_path}
            cd ${container_dest_path}
            echo "Copying ${key} from S3 bucket ${bucket}..."
            aws s3 cp "s3://${bucket}/${key}" . --region ${region}

            # echo "Unzipping ${key}..."
            # unzip ${key}

            # if [ -f ${base}.ini ]; then
            #     echo "Rendering POV-Ray scene ${base}..."
            #     if povray ${base}; then
            #         if [ -f ${base}.png ]; then
            #             echo "Copying result image ${base}.png to s3://${bucket}/${base}.png..."
            #             aws s3 cp ${base}.png s3://${bucket}/${base}.png
            #         else
            #             echo "ERROR: POV-Ray source did not generate ${base}.png image."
            #         fi
            #     else
            #         echo "ERROR: POV-Ray source did not render successfully."
            #     fi
            # else
            #     echo "ERROR: No ${base}.ini file found in POV-Ray source archive."
            # fi

            # popd

            echo "Deleting message..."
            aws sqs delete-message \
                --queue-url ${queue} \
                --region ${region} \
                --receipt-handle "${receipt_handle}"
        else
            echo "ERROR: Could not extract S3 bucket and key from SQS message."
        fi
    fi
done

# aws ecs register-task-definition --cli-input-json file://<path_to_json_file>/sleep360.json

# aws ecs register-task-definition --family sleep360 --container-definitions "[{\"name\":\"sleep\",\"image\":\"busybox\",\"cpu\":10,\"command\":[\"sleep\",\"360\"],\"memory\":10,\"essential\":true}]"

# https://medium.com/@sunnykay/deployment-pipeline-deploy-app-to-aws-ecs-using-aws-cli-13919ab7a097
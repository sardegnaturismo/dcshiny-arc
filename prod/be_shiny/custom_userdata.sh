--==BOUNDARY==
Content-Type: text/text/x-shellscript; charset="us-ascii"

#!/bin/bash

# Install nfs-utils
yum update -y
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
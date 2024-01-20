#!/bin/bash
if command -v aws &> /dev/null
then
   aws_version=$(aws --version | cut -d "/" -f 2 | cut -d " " -f 1)
   echo "AWS CLI is successfully installed with version $aws_version"
else
    echo "AWS CLI not found. Installing..."
    sudo apt-get update
    sudo apt-get install unzip -y
    sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi
instance_id=$(cat /var/lib/cloud/data/instance-id)
while true
do
  cpu_cores=$(nproc)
  load_average_5min=$(cat /proc/loadavg | awk '{print $2}')
  echo "5-Minute Load Average: $load_average_5min"
  echo "Instance ID: $instance_id"
  load_percentage=$(echo "scale=2; ($load_average_5min / $cpu_cores) * 100" | bc)
  echo "Load Percentage: $load_percentage"
  aws cloudwatch put-metric-data --metric-name "ec2_load_percentage" --namespace "ServerLoad" --dimensions Instance=$instance_id --value $load_percentage
  sleep 40
done
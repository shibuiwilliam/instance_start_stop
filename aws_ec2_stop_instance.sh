#!/bin/bash
# date: 2017/01/06
# author: cvusk

log=/tmp/aws_cli.log

# specify stopping instances by its tag key and value
tag_key="ec2-key"
tag_value="stop_this"

echo "####################################" >> ${log}
echo "##### executing stop-instances #####" >> ${log}
date >> ${log}

getaws=`getawskey`

echo "     ###### getawskey ######" >> ${log}
echo ${getaws} >> ${log}

instances=`aws ec2 describe-instances --filters "Name=tag:${tag_key},Values=${tag_value}"`
instance_ids=`echo $instances | jq -r '.Reservations[].Instances[].InstanceId'`

stop=`aws ec2 stop-instances --instance-ids $instance_ids`

aws ec2 wait instance-stopped --instance-ids ${instance_ids}

date >> ${log}
echo "     ###### stop-instances ######" >> ${log}
echo "stopped instances:" >> ${log}
echo ${instance_ids} >> ${log}
echo ${stop} >> ${log}
echo "##### done stop-instances #####" >> ${log}
echo "####################################" >> ${log}
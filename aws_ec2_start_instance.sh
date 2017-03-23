#!/bin/bash
# date: 2017/01/06
# author: cvusk

log=/tmp/aws_cli.log

# specify starting instances by its tag key and value
tag_key="ec2-key"
tag_value="start_this"

echo "####################################" >> ${log}
echo "##### executing start-instances #####" >> ${log}
date >> ${log}

getaws=`getawskey`

echo "     ###### getawskey ######" >> ${log}
echo ${getaws} >> ${log}

instances=`aws ec2 describe-instances --filters "Name=tag:${tag_key},Values=${tag_value}"`
instance_ids=`echo $instances | jq -r '.Reservations[].Instances[].InstanceId'`

start=`aws ec2 start-instances --instance-ids $instance_ids`

aws ec2 wait instance-status-ok --instance-ids ${instance_ids}

date >> ${log}
echo "     ###### start-instances ######" >> ${log}
echo "started instances:" >> ${log}
echo ${instance_ids} >> ${log}
echo ${start} >> ${log}
echo "##### done start-instances #####" >> ${log}
echo "####################################" >> ${log}

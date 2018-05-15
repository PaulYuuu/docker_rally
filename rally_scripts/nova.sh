#!/bin/bash

mkdir -p nova/{log,html}

rally_task_dir=../../source/samples/tasks/scenarios
nova_case=`find $rally_task_dir/nova -name "*.yaml"`

for case in $nova_case
do
	#Create rally log
    name=`echo $case | awk -F "/" '{print $NF}' | cut -d "." -f 1`
    rally --log-file nova/log/$name.log task start --task $case
    #Create rally report
    uuid=`rally task status | awk '{print $2}' | tr -d :`
    rally task report $uuid --out nova/html/$name.html
done
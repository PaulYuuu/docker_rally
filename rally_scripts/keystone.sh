#!/bin/bash

mkdir -p keystone/{log,html}

rally_task_dir=../../source/samples/tasks/scenarios
keystone_case=`find $rally_task_dir/keystone -name "*.yaml"`

for case in $keystone_case
do
	#Create rally log
    name=`echo $case | awk -F "/" '{print $NF}' | cut -d "." -f 1`
    rally --log-file keystone/log/$name.log task start --task $case
    #Create rally report
    uuid=`rally task status | awk '{print $2}' | tr -d :`
    rally task report $uuid --out keystone/html/$name.html
done

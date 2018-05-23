#!/bin/bash

mkdir -p glance/{log,html}
rally_task_dir=../../source/samples/tasks/scenarios
glance_case=`find $rally_task_dir/glance -name "*.yaml"`

for case in $glance_case
do
	#Create rally log
    name=`echo $case | awk -F "/" '{print $NF}' | cut -d "." -f 1`
    rally --log-file glance/log/$name.log task start --task $case
    #Create rally report
    uuid=`rally task status | awk '{print $2}' | tr -d :`
    rally task report $uuid --out glance/html/$name.html
done

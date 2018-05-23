#!/bin/bash

mkdir -p cinder/{log,html}
rally_task_dir=../../source/samples/tasks/scenarios
cinder_case=`find $rally_task_dir/cinder -name "*.yaml"`

for case in $cinder_case
do
	#Create rally log
    name=`echo $case | awk -F "/" '{print $NF}' | cut -d "." -f 1`
    rally --log-file cinder/log/$name.log task start --task $case
    #Create rally report
    uuid=`rally task status | awk '{print $2}' | tr -d :`
    rally task report $uuid --out cinder/html/$name.html
done

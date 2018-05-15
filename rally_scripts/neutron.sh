#!/bin/bash

mkdir -p neutron/{log,html}

rally_task_dir=../../source/samples/tasks/scenarios
neutron_case=`find $rally_task_dir/neutron -name "*.yaml"`

for case in $neutron_case
do
	#Create rally log
    name=`echo $case | awk -F "/" '{print $NF}' | cut -d "." -f 1`
    rally --log-file neutron/log/$name.log task start --task $case
    #Create rally report
    uuid=`rally task status | awk '{print $2}' | tr -d :`
    rally task report $uuid --out neutron/html/$name.html
done
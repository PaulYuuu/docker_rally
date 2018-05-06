#!/bin/bash

script_dir=$(cd `dirname $0`; pwd)
cd $script_dir

if [ ! -d ../testcase_result/glance ];then
    mkdir ../testcase_result/glance
fi

rally_task_dir=source/samples/tasks/scenarios
glance_case=`find ../$rally_task_dir/glance -name "*.yaml"`

for case in $glance_case
do
    name=`echo $case | awk -F "/" '{print $NF}' | cut -d "." -f 1`
    rally --log-file ../testcase_result/glance/$name.log task start --task $case
    #Create rally report
    uuid=`rally task status | awk '{print $2}' | tr -d :`
    rally task report $uuid --out ../testcase_result/glance"_"$name"_"$uuid.html
done

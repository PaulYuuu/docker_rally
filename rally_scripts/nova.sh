#!/bin/bash

script_dir=$(cd `dirname $0`; pwd)
cd $script_dir

if [ ! -d ../testcase_result/nova ];then
    mkdir ../testcase_result/nova
fi

rally_task_dir=source/samples/tasks/scenarios
nova_case=`find ../$rally_task_dir/nova -name "*.yaml"`

for case in $nova_case
do
    name=`echo $case | awk -F "/" '{print $NF}' | cut -d "." -f 1`
    rally --log-file ../testcase_result/nova/$name.log task start --task $case
    #Create rally report
    uuid=`rally task status | awk '{print $2}' | tr -d :`
    rally task report $uuid --out ../testcase_result/nova"_"$name"_"$uuid.html
done

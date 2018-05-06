#!/bin/bash

script_dir=$(cd `dirname $0`; pwd)
cd $script_dir

if [ ! -d ../testcase_result/neutron ];then
    mkdir ../testcase_result/neutron
fi

rally_task_dir=source/samples/tasks/scenarios
neutron_case=`find ../$rally_task_dir/neutron -name "*.yaml"`

for case in $neutron_case
do
    name=`echo $case | awk -F "/" '{print $NF}' | cut -d "." -f 1`
    rally --log-file ../testcase_result/neutron/$name.log task start --task $case
    #Create rally report
    uuid=`rally task status | awk '{print $2}' | tr -d :`
    rally task report $uuid --out ../testcase_result/neutron"_"$name"_"$uuid.html
done

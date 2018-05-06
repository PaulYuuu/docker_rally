#!/bin/bash

script_dir=$(cd `dirname $0`; pwd)
cd $script_dir

if [ ! -d testcase_result ];then
    mkdir testcase_result
fi

testcase_file=testcase_result/rally_testcase.txt
total_file=testcase_result/rally_total.txt
rally_task_dir=source/samples/tasks/scenarios

#keystone
keystone_case=`find $rally_task_dir/keystone -name "*.yaml"`
keystone_num=`grep -rn '\<KeystoneBasic' $keystone_case | wc -l`
echo "Keystone Testcases Number: "$keystone_num > $total_file
echo "#Keystone" > $testcase_file
keystone_name=`grep -rn '\<KeystoneBasic' $keystone_case | awk '{print NR":",$2}' >> $testcase_file`
sed -i 's/Keystone.*\.//g' $testcase_file

#glance
glance_case=`find $rally_task_dir/glance -name "*.yaml"`
glance_num=`grep -rn '\<GlanceImages' $glance_case | wc -l`
echo "Glance Testcases Number: "$glance_num >> $total_file
echo "#Glance" >> $testcase_file
glance_name=`grep -rn '\<GlanceImages' $glance_case | awk '{print NR":",$2}' >> $testcase_file`
sed -i 's/Glance.*\.//g' $testcase_file

#nova
nova_case=`find $rally_task_dir/nova -name "*.yaml"`
nova_num=`grep -rn '\<Nova' $nova_case | wc -l`
echo "Nova Testcases Number: "$nova_num >> $total_file
echo "#Nova" >> $testcase_file
nova_name=`grep -rn '\<Nova' $nova_case | awk '{print NR":",$2}' >> $testcase_file`
sed -i 's/Nova.*\.//g' $testcase_file

#neutron
neutron_case=`find $rally_task_dir/neutron -name "*.yaml"`
neutron_num=`grep -rn '\<Neutron' $neutron_case | wc -l`
echo "Neutron Testcases Number: "$neutron_num >> $total_file
echo "#Neutron" >> $testcase_file
neutron_name=`grep -rn '\<Neutron' $neutron_case | awk '{print NR":",$2}' >> $testcase_file`
sed -i 's/Neutron.*\.//g' $testcase_file

#cinder
cinder_case=`find $rally_task_dir/cinder -name "*.yaml"`
cinder_num=`grep -rn '\<CinderVolumes' $cinder_case | wc -l`
echo "Cinder Testcases Number: "$cinder_num >> $total_file
echo "#Cinder" >> $testcase_file
cinder_name=`grep -rn '\<CinderVolumes' $cinder_case | awk '{print NR":",$2}' >> $testcase_file`
sed -i 's/Cinder.*\.//g' $testcase_file

#total
let total=$keystone_num+$glance_num+$nova_num+$neutron_num+$cinder_num
echo "Total Testcases Number: $total" >> $total_file
sed -i 's/:$//' $testcase_file

# Run Scripts tests
for i in rally_scripts/*.sh
do
    bash $i
done

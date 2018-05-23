#!/bin/bash

cd `dirname $0`
time=`date +%H:%M:%S`
mkdir -p testcase_result/$time

testcase_file=testcase_result/$time/rally_testcase.txt
total_file=testcase_result/$time/rally_total.txt
rally_task_dir=source/samples/tasks/scenarios

#keystone
keystone_case=`find $rally_task_dir/keystone -name "*.yaml"`
keystone_num=`grep -rn '\<Keystone' $keystone_case | wc -l`
echo "Keystone Testcases Number: "$keystone_num > $total_file
echo "Keystone" > $testcase_file
grep -rn '\<Keystone' $keystone_case | awk '{print NR":",$2}' >> $testcase_file
sed -i 's/Keystone.*\.//g' $testcase_file

#glance
glance_case=`find $rally_task_dir/glance -name "*.yaml"`
glance_num=`grep -rn '\<Glance' $glance_case | wc -l`
echo "Glance Testcases Number: "$glance_num >> $total_file
echo "" >> $testcase_file
echo "Glance" >> $testcase_file
grep -rn '\<Glance' $glance_case | awk '{print NR":",$2}' >> $testcase_file
sed -i 's/Glance.*\.//g' $testcase_file

#nova
nova_case=`find $rally_task_dir/nova -name "*.yaml"`
nova_num=`grep -rn '\<Nova' $nova_case | wc -l`
echo "Nova Testcases Number: "$nova_num >> $total_file
echo "" >> $testcase_file
echo "Nova" >> $testcase_file
grep -rn '\<Nova' $nova_case | awk '{print NR":",$2}' >> $testcase_file
sed -i 's/Nova.*\.//g' $testcase_file

#neutron
neutron_case=`find $rally_task_dir/neutron -name "*.yaml"`
neutron_num=`grep -rn '\<Neutron' $neutron_case | wc -l`
echo "Neutron Testcases Number: "$neutron_num >> $total_file
echo "" >> $testcase_file
echo "Neutron" >> $testcase_file
grep -rn '\<Neutron' $neutron_case | awk '{print NR":",$2}' >> $testcase_file
sed -i 's/Neutron.*\.//g' $testcase_file

#cinder
cinder_case=`find $rally_task_dir/cinder -name "*.yaml"`
cinder_num=`grep -rn '\<Cinder' $cinder_case | wc -l`
echo "Cinder Testcases Number: "$cinder_num >> $total_file
echo "" >> $testcase_file
echo "Cinder" >> $testcase_file
grep -rn '\<Cinder' $cinder_case | awk '{print NR":",$2}' >> $testcase_file
sed -i 's/Cinder.*\.//g' $testcase_file

#total
let total=$keystone_num+$glance_num+$nova_num+$neutron_num+$cinder_num
echo "Total Testcases Number: $total" >> $total_file
sed -i 's/:$//' $testcase_file

# Run Scripts tests
cd testcase_result/$time
for i in ../../rally_scripts/*.sh
do
    bash $i
done

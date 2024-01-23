#!/bin/bash
component=$1
environment=$2
yum install python3.11-devel python3.11-pip -y
pip3.11 install ansible botocore boto3
ansible-pull -U https://github.com/NarayanadasuRakesh/automation-with-terraform-ansible-V2/tree/master/ansible-roles-for-tf -e component=$component -e environment=$environment main-tf.yml
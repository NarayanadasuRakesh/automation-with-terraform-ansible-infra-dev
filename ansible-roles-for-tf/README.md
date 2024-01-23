# automation-with-ansible-roles
This repository contains Ansible playbooks for the configuration of microservices.

Follow below order while executing yaml files:

1) DATABASE SERVERS SETUP<br/>mondodb - redis - mysql - rabbitmq

2) APPLICATION SERVERS SETUP<br/>catalogue - user - cart - shipping - payment - dispatch

3) WEB SERVER SETUP<br/>web

Add your domain names or IP addresses in variables.yml and inventory.ini files

To run a playbook
```
ansible-playbook -e component=<server-name> main.yml
```
Example:<br/>
To run a mongodb server
```
ansible-playbook -e component=mongodb main.yml
```
To run a catalogue server
```
ansible-playbook -e component=catalogue main.yml
```

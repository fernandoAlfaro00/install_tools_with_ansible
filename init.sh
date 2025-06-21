#!/bin/bash
sudo apt  install curl -y
python3 -m venv venv_ansible
venv_ansible/bin/pip3 install ansible
venv_ansible/bin/ansible-playbook --ask-become-pass main.yaml
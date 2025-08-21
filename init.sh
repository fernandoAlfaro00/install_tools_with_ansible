#!/bin/bash
sudo apt  install curl -y
python3 -m venv venv_ansible
venv_ansible/bin/pip3 install ansible
source venv_ansible/bin/activate
echo -e "====================================================================="
echo -e "\033[0;31mIntroduce tu password sudo para avanzar con la instalacion\033[0m"
ansible-playbook --ask-become-pass main.yaml --tags kvm-qemu
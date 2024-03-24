#!/bin/bash
sudo apt  install curl -y
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
python3 -m pip install --user ansible
export PATH=$PATH:~/.local/bin
ansible-playbook --ask-become-pass main.yaml

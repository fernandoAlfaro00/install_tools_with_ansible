#!/bin/bash
cleanup() {
    rm -rf venv_ansible
    echo -e "\033[0;32mCleaned venv_ansible\033[0m"
}
trap cleanup EXIT

spinner() {
    pid=$1
    msg=$2
    spin='|/-\'
    i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${spin:$i:1} $msg"
        sleep 0.1
    done
    echo -e "\r\033[0;32m$msg... Done!\033[0m      "
}

echo -e "\033[0;36mInitializing virtual environment...\033[0m"
python3 -m venv venv_ansible 
venv_ansible/bin/pip3 -q install ansible &
pid=$!
spinner $pid "Installing Ansible" 

source venv_ansible/bin/activate
echo -e "====================================================================="
echo -e "\033[0;31mEnter your sudo password to continue with the installation\033[0m"

ansible-playbook --ask-become-pass main.yaml --tags kvmqemu

if [ $? -eq 0 ]; then
    echo -e "\033[0;36mAll tasks completed successfully! ✅\033[0m"
else
    echo -e "\033[0;31mTasks did not complete successfully!\033[0m"
fi

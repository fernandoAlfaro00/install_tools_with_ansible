# Install Tools with Ansible

# Requirements
- Python 3.x
- Curl 
- Dialog

# Tested OS

| Distribution | Tested | Status             |
|-------------|--------|------------------|
| Debian 12   | ✅      |Work in progress  |



# Tools to Install
- KVM/Qemu
- Docker
- Minikube
- AWS Client
- Terraform
- Vagrant
- kubectl
- etc



# Install Ansible in a Virtual Environment
```bash
sudo apt  install curl -y
sudo apt install dialog -y
python3 -m venv venv_ansible
venv_ansible/bin/pip3 install ansible
source venv_ansible/bin/activate
```

# Run a Playbook

```bash 
ansible-playbook --ask-become-pass <playbook.yaml>
```


# Create the Virtual Environment and Run the Main Playbook 

```bash
./init.sh
```

# Dev Mode

```bash
export DEV_MODE=true
```


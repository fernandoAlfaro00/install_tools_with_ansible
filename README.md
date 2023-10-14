# install_tools_with_ansible


# install ansible 

```bash
sudo apt  install curl

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

python3 get-pip.py --user

python3 -m pip -V

python3 -m pip install --user ansible

python3 -m pip list

export PATH=$PATH:~/.local/bin

ansible --version

```

# Uso 


```ansible-playbook --ask-become-pass <playbook.yml>```

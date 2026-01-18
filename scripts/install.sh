#!/bin/bash
set -o pipefail
set -x
PATH_SCRIPTS="$PWD/scripts"

# Colors
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"
CYAN="\e[0;36m"

install_required_packages() {

    echo -e "${CYAN}Verificando dependecias necesarias...${RESET}"
    echo -e "${CYAN}Verificado version python instalada...${RESET}"
    python_binary=$(command -v python3  || command -v python)
    if $python_binary --version >/dev/null 2>&1; then
        
        echo -e "Debug: Version de Python: $($python_binary --version)"
    else  
        echo -e "${RED}Error: Python no instalado en el sistema, asegurese de tener instalado una version 1.13 o superior ${RESET}"
        exit 1
    fi 

    #Verificacion de Curl
    if command -v curl >/dev/null 2>&1; then
        echo -e "Debug: Curl listo"
    else  
        echo -e "${RED}Error: Curl no instalado, dependecia necesaria${RESET}"
        exit 1
    fi 

    #Verificacion de Dialog
    if command -v dialog >/dev/null 2>&1; then
        echo -e "Debug: Dialog listo"
    else  
        echo -e "${RED}Error: Dialog no instalado, dependecia necesaria${RESET}"
        exit 1
    fi 

    if command -v uv >/dev/null 2>&1 ; then
        echo -e "${GREEN}uv esta instalado${RESET}"
    else 
        if curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1; then
            echo -e "${GREEN}uv instalación completa${RESET}"
        else
            echo -e "${RED}Error: no se pudo descargar o instalar uv${RESET}"
            exit 1
        fi 
    fi 
}

install_required_packages
echo -e "${CYAN}Initializing virtual environment...${RESET}"
uv venv --python 3.13 -qq --seed --no-project --clear .venv
.venv/bin/pip3 install ansible --quiet

echo "Activacion entorno virtual"
source $PWD/.venv/bin/activate

echo -e "====================================================================="
echo -e "\033[0;31mEnter your sudo password to continue with the installation\033[0m"
source "$PATH_SCRIPTS/menu.sh" 

sleep 0.5 

EXTRA_VARS=$(<$PWD/temp_option_select)

CMD="ansible-playbook --ask-become-pass main.yaml -e "$EXTRA_VARS" $ANSIBLE_CHECK"

eval $CMD

if [ $? -eq 0 ]; then
    echo -e "\033[0;36mAll tasks completed successfully! ✅\033[0m"
    exit 0
else
    echo -e "\033[0;31mTasks did not complete successfully!\033[0m"
    exit 1
fi

#!/bin/bash
set -o pipefail

#GLOBAL VARIABLES
LOGS_EXECUTION=$HOME/install_tools_$(date '+%Y%m%d_%H%M%S_%3N').log

# date '+%Y-%m-%d %H:%M:%S')
MENU_SELECTED_OPTION=""
PATH_SCRIPTS="$PWD/scripts"

# Colors
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"
CYAN="\e[0;36m"


exec > >(tee -a $LOGS_EXECUTION) 2>&1

DEBUG=false

debug_logs () {
    
    if [ "$DEBUG" = true ]; then
        echo -e "[DEBUG] $*"
    fi
}


install_required_packages() {

    echo -e "${CYAN}Verificando dependecias necesarias...${RESET}" 
    echo -e "${CYAN}Verificado version python instalada...${RESET}"
    python_binary=$(command -v python3  || command -v python)
    if $python_binary --version >/dev/null 2>&1; then
        
        debug_logs "Version de Python: $($python_binary --version)"
    else  
        echo -e "${RED}Error: Python no instalado en el sistema, asegurese de tener instalado una version 1.13 o superior ${RESET}"
        exit 1
    fi 

    #Verificacion de Curl
    if command -v curl >/dev/null 2>&1; then
        debug_logs "Curl listo"
    else  
        echo -e "${RED}Error: Curl no instalado, dependecia necesaria${RESET}"
        exit 1
    fi 

    #Verificacion de Dialog
    if command -v dialog >/dev/null 2>&1; then
        debug_logs "Dialog listo"
    else  
        echo -e "${RED}Error: Dialog no instalado, dependecia necesaria${RESET}"
        exit 1
    fi 

    if command -v uv >/dev/null 2>&1 ; then
        debug_logs "${GREEN}uv esta instalado${RESET}"
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
.venv/bin/pip3 install ansible==13.2.0 --quiet

echo "Activacion entorno virtual"
source $PWD/.venv/bin/activate


source "$PATH_SCRIPTS/menu.sh" 

sleep 0.5 

debug_logs $MENU_SELECTED_OPTION

CMD="ansible-playbook --ask-become-pass main.yaml $MENU_SELECTED_OPTION"

echo -e "${RED}=====================================================================${RESET}"
echo -e "${RED} Ingrese su password para continuar con la instalacion ${RESET}"
eval $CMD

# jq -r '
#   .plays[].tasks[] |
#   .task.name as $task |
#   .hosts | to_entries[] |
#   select(.value.skipped != true) |
#   "[TASK] \($task)"
# '

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Todos los paquetes se han instalado correctamente!${RESET}"
    exit 0
else
    echo -e "${RED}Hubo un problema a la hora de instalar los paquetes!${RESET}"
    exit 1
fi

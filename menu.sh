#!/bin/bash

# Variables por defecto
install_devops=false
install_virtualization=false
install_utilities=false

# Menú de perfiles
PROFILE=$(dialog --clear --menu "Selecciona un perfil" 15 50 4 \
1 "DevOps" \
2 "Virtualización" \
3 "Utilities" \
4 "Salir" 2>&1 >/dev/tty)

clear

EXTRA_VARS="install_devops=false install_virtualization=false install_utilities=false"

case $PROFILE in
  1)
    install_devops=true
    CHOICES=$(dialog --separate-output --checklist "Selecciona herramientas DevOps:" 15 50 5 \
    docker "" off \
    podman "" off \
    kubectl "" off \
    helm "" off \
    terraform "" off 2>&1 >/dev/tty)
    ;;
  2)
    install_virtualization=true
    CHOICES=$(dialog --separate-output --checklist "Selecciona herramientas Virtualización:" 15 50 3 \
    kvm "" off \
    vagrant "" off 2>&1 >/dev/tty)
    ;;
  3)
    install_utilities=true
    CHOICES=$(dialog --separate-output --checklist "Selecciona Utilities:" 15 50 5 \
    zsh "" off \
    rofi "" off \
    copyq "" off \
    vscode "" off \
    discord "" off 2>&1 >/dev/tty)
    ;;
  4)
    exit 0
    ;;
esac

clear

# Marcar las categorías seleccionadas
EXTRA_VARS="install_devops=$install_devops install_virtualization=$install_virtualization install_utilities=$install_utilities"

# Marcar herramientas seleccionadas
for item in $CHOICES; do
  EXTRA_VARS="$EXTRA_VARS install_$item=true"
done

# Ejecutar Ansible
echo \"$EXTRA_VARS\" > temp_option_select

clear
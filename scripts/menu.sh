#!/bin/bash
PROFILE_CHOICE=""
TOOLS_CHOICES=""
main() {
  profiles_menu
  tools_menu
  clear
}

#Menú de perfiles
profiles_menu() {
  debug_logs "Funcion: profiles_menu"
  PROFILE_CHOICE=$(dialog --clear --menu "Selecciona un perfil" 15 50 4 \
  1 "DevOps" \
  2 "Virtualización" \
  3 "Utilities" \
  4 "Salir" 2>&1 >/dev/tty)
  status_exit_profile=$?

  debug_logs "Perfil seleccionado : $PROFILE_CHOICE"

  if [ $status_exit_profile -eq 1 ]; then
    debug_logs "Se presiono btn cancel"
    clear
    exit 0
  fi
  clear
}

#Menú de herramientas
tools_menu() {
  debug_logs "Funcion: tools_menu"
  install_devops=false
  install_virtualization=false
  install_utilities=false

  case $PROFILE_CHOICE in
    1)
      install_devops=true
      TOOLS_CHOICES=$(dialog --separate-output --checklist "Selecciona herramientas DevOps:" 15 50 5 \
      docker "" off \
      aws_cli "" off \
      kubectl "" off \
      helm "" off \
      minikube "" off \
      stern "" off \
      terraform "" off 2>&1 >/dev/tty)
      ;;
    2)
      install_virtualization=true
      TOOLS_CHOICES=$(dialog --separate-output --checklist "Selecciona herramientas Virtualización:" 15 50 3 \
      kvm "" off \
      vagrant "" off 2>&1 >/dev/tty)
      ;;
    3)
      install_utilities=true
      TOOLS_CHOICES=$(dialog --separate-output --checklist "Selecciona Utilities:" 15 50 5 \
      zsh "" off \
      fzf "" off \
      vim "" off \
      rofi "" off \
      htop "" off \
      copyq "" off \
      vscode "" off \
      timeshift "" off \
      brave "" off \
      discord "" off 2>&1 >/dev/tty)
      ;;
    4)
      exit 0
      ;;
  esac

  status_select_tools=$?
  debug_logs   "herramientas seleccionadas: $TOOLS_CHOICES"
  if [ $status_select_tools -gt 0 ]; then
    main
  fi
  clear

  # Marcar las categorías seleccionadas
  MENU_SELECTED_OPTION="-e install_devops=$install_devops -e install_virtualization=$install_virtualization -e install_utilities=$install_utilities"

  if [[ -z $TOOLS_CHOICES  ]]; then 
    debug_logs   "No se selecciono ninguna herramienta a instalar"
    dialog --title "Aviso" --msgbox "Por favor seleccionar una opción" 8 50
    clear
    main
  fi
  
  # Marcar herramientas seleccionadas
  for item in $TOOLS_CHOICES; do
    MENU_SELECTED_OPTION="$MENU_SELECTED_OPTION -e install_$item=true"
  done

}

main

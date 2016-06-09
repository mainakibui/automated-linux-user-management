#!/bin/bash

#check if user is root
if [ $(id -u) -eq 0 ]; then

  clear
  echo "-----------------USER MANAGEMENT MENU-----------------"
  echo "Select an option below"
  echo "------------------------------------------------------"
  printf '%s\n' "r : Check users"
  printf '%s\n' "c : Add users"
  printf '%s\n' "d : Delete users"
  printf '%s\n' "a : About this script"
  printf '%s\n' "q : Quit"
  read -p "Enter option : " option

  case "$option" in

    r)  clear
    printf '\n\t%s\n' "$option selected. Checking for users."
    ./checkuser.sh
    ;;
    c)  clear
    printf '\n\t%s\n' "$option selected. Adding users."
    ./addusers.sh
    ;;
    d)  clear
    printf '\n\t%s\n' "$option selected. Deleting users."
    ./deleteuser.sh
    ;;
    a)  clear
    printf '\n\t%s\n' "$option selected. About this script."
    about=$(<about.txt)
    echo -e $about
    ;;
    q)  clear
    printf '\n\t%s\n' "$option selected. Quiting script."
    exit 1
    ;;
    *) printf '\n\t%s\n' "$option is not understood. Quiting anyway."
    exit 1
    ;;
  esac

  echo "------------------------------------------------------"

else
  printf '\n%s\n' "Change to root to access all the features of this script."
  exit 2
fi

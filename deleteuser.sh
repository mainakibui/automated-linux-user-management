#!/bin/bash

##
#This script deletes users if they exist
##

deleteuser(){
  #check if user is root
  if [ $(id -u) -eq 0 ]; then

    #username=James
    read -p "Enter username : " username

    egrep "^$username" /etc/passwd >/dev/null

    if [ $? -eq 0 ]; then
      printf "\tUser: %s exists \n" $username
      read -p "Are you sure you want to delete? (Yy to accept any other key to terminate): " -n 1 -r

      if [[ $REPLY =~ ^[Yy]$ ]]
      then
        printf "\n\tProceeding to delete : %s \n" $username
        userdel $username
        rm -rf "/home/${username}"
        printf "\n\tUser %s deleted \n" $username
      else
        printf "\n \nNo action was performed goodbye.\n"
      fi

    else
      printf "%s does not exist. No action performed.\n" $username
    fi

  else
    printf '\n%s\n' "Only root may delete a user in the system"
  fi
}

while : ; do
  deleteuser
  read -p "Delete annother user ?(Yy to accept any other key to terminate) " option
  [[ $option =~ ^[Yy]$ ]] || break
done

printf '\n%s\n' "Return to menu: (m) Quit: (q)"
read -p "Select an option to proceed : " option

case "$option" in

  m)  clear
  printf '\n\t%s\n' "$option selected. Returning to menu."
  ./menu.sh
  ;;
  q)  printf '\n\t%s\n' "$option selected. Quiting script."
  exit 1
  ;;
  *) printf '\n\t%s\n' "$option is not understood. Quiting anyway."
  ;;
esac

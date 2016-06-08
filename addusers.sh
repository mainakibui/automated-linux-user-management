#!/bin/bash
##
#NB: replace group-name with the name of the group you will provide with sudo pridviledges
#(creation of that group is not covered in this script)
##

adduserfromfiles(){
  #check if user is root
  if [ $(id -u) -eq 0 ]; then

    # Assign file descriptors to users and passwords files
    exec 3< users.txt
    exec 4< userkeys.txt

    # Read user and password
    while read iuser <&3 && read iuserkey <&4 ; do

      #check if user exists
      egrep "^$iuser" /etc/passwd >/dev/null
      if [ $? -eq 0 ]; then
        printf '\n%s\n' "$iuser EXISTS! This user will not be added."
      else
        printf '\n%s\n' "$iuser does not exist! Proceeding to add them."

        #Generate random password
        ipasswd=$(openssl rand -base64 32)

        # Just print this for debugging
        printf "\tCreating user: %s with password: %s\n" $iuser $ipasswd

        # Create the user with adduser
        adduser $iuser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password

        # Assign the password to the user, passwd must read it from stdin
        passwd "$iuser" <<<"$ipasswd"$'\n'"$ipasswd"

        #Add user to group-name group
        usermod -a -G group-name $iuser

        #Create ssh folder and set the required permissions
        printf '\t%s\n' "creating ssh folder /home/${iuser}/.ssh"
        mkdir "/home/${iuser}/.ssh"
        chmod 0700 "/home/${iuser}/.ssh"
        touch "/home/${iuser}/.ssh/authorized_keys"
        chmod 0600 "/home/${iuser}/.ssh/authorized_keys"

        #Grant user ownership of file else they will be required to enter a ssh password to authenticate even when no password is set in sshd_config
        chown -R $iuser:$iuser "/home/${iuser}/.ssh"

        #write key to file
        destinationdirectory="/home/${iuser}/.ssh/authorized_keys"

        if [ -f "$destinationdirectory" ]
        then
          printf '\t%s\n' "Adding user ssh key"
          echo "$iuserkey" > "$destinationdirectory"
        fi

        printf "\tUser: %s was added \n" $iuser

      fi

    done

  else
    printf '\n%s\n' "Only root may add a user to the system"
  fi
}

adduserfromprompt(){
  #check if user is root
  if [ $(id -u) -eq 0 ]; then

    # Prompt for username and password
    read -p "Enter new users username: " iuser
    read -p "Enter new users password: " ipasswd

    #check if user exists
    egrep "^$iuser" /etc/passwd >/dev/null
    if [ $? -eq 0 ]; then
      printf '\n%s\n' "$iuser EXISTS! This user will not be added."
    else
      printf '\n%s\n' "$iuser does not exist! Proceeding to add them."

      # Just print this for debugging
      printf "\tCreating user: %s with password: %s\n" $iuser $ipasswd

      # Create the user with adduser
      adduser $iuser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password

      # Assign the password to the user, passwd must read it from stdin
      passwd "$iuser" <<<"$ipasswd"$'\n'"$ipasswd"

      #Add user to group-name group
      usermod -a -G group-name $iuser

      #Create ssh folder and set the required permissions
      printf '\t%s\n' "creating ssh folder /home/${iuser}/.ssh"
      mkdir "/home/${iuser}/.ssh"
      chmod 0700 "/home/${iuser}/.ssh"
      touch "/home/${iuser}/.ssh/authorized_keys"
      chmod 0600 "/home/${iuser}/.ssh/authorized_keys"

      #Grant user ownership of file else they will be required to enter a ssh password to authenticate even when no password is set in sshd_config
      chown -R $iuser:$iuser "/home/${iuser}/.ssh"

      #write key to file
      read -p "Enter new users public key: " iuserkey
      destinationdirectory="/home/${iuser}/.ssh/authorized_keys"

      if [ -f "$destinationdirectory" ]
      then
        printf '\t%s\n' "Adding user ssh key"
        echo "$iuserkey" > "$destinationdirectory"
      fi

      printf "\tUser: %s was added \n" $iuser

    fi

  else
    printf '\n%s\n' "Only root may add a user to the system"
  fi
}



while : ; do
  #Prompt for action to perform
  printf '\n%s\n' "Return to menu: (m) Add user from varriables in file: (f) Add user from prompt: (p)"
  read -p "Select an option to proceed : " option

  #switch between using the files and adding the information when prompted
  case "$option" in

    f)  clear
    printf '\n\t%s\n' "$option selected. Add users from file."
    adduserfromfiles
    ;;
    p)  clear
    printf '\n\t%s\n' "$option selected. Add users from prompt."
    adduserfromprompt
    ;;
    m)  clear
    printf '\n\t%s\n' "$option selected. Returning to main menu."
    ./menu.sh
    ;;
    *) printf '\n\t%s\n' "$option is not understood. Returning to main menu anyway."
    ./menu.sh
    ;;
  esac

  read -p "Add annother user ?(Yy to accept any other key to terminate) " option
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

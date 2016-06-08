#!/bin/bash

#check if user is root
if [ $(id -u) -eq 0 ]; then

  chmod u+x addusers.sh
  chmod u+x checkuser.sh
  chmod u+x deleteuser.sh
  chmod u+x menu.sh

else
  printf '\n%s\n' "You are not root. Please change to root before using any of these scripts."
fi

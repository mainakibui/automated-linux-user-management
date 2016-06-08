#!/bin/bash

checkuser(){
	#username=nathan
	read -p "Enter username : " username

	egrep "^$username" /etc/passwd >/dev/null

	if [ $? -eq 0 ]; then
		printf '\n%s\n' "$username EXISTS!"
	else
		printf '\n%s\n' "$username does not exist!"
	fi
}

while : ; do
	checkuser
	read -p "Check annother user ?(Yy to accept any other key to terminate) " option
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

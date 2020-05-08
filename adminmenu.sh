#!/bin/bash
#Triggers when an administrator logs in with their account

#Prevent login of other terminals by looking through running processes

adminmenu()
{
clear
echo "Admin menu" | figlet
echo -ne "Locking the system and preventing anyone from logging in\n"
touch .LOCK
echo -ne "The system cannot be logged in on at the moment \n"
echo -ne "\nWelcome system administrator! Password reset would happen on "$(cat .displayexpirydate)"
Please select any of the admin tools listed below.

a) Add Item
b) View / Edit / Delete Item
c) Set Highlights
d) Change Password
e) Discount Card
f) Logout

Your selection: "
read key

	case $key in
	A|a)	clear
		echo "You have chosen to add new products!"
		sleep 1
		bash adminadditem.sh ;;

	B|b)	clear
		echo "Bringing you to the item modification screen!"
		sleep 1
		bash adminmodifyitem.sh ;;

	C|c)	clear
		echo "Modifying the highlighted products!"
		sleep 1
		bash adminhighlight.sh	;;

	D|d)	clear
		echo "Loading administrator password change option"
		sleep 1
		bash adminchangepass.sh	;;

	E|e)	clear
		echo "Going to the configuration for customer discounts!"
		sleep 1
		bash admindiscountcard.sh
		;;

	F|f)	clear
		echo "Log out" | figlet
		echo "Logging out. Bringing you back to the login screen and enabling logging in again"
		rm -f .LOCK		
		sleep 1
		bash mp.sh ;;

	*)	echo "Invalid option selected! Please try again"
		sleep 1
		adminmenu ;;
	esac
}

#Calling of Functions
adminmenu

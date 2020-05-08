#!/bin/bash
#Login Script
#Tests if the login screen is locked or not
testforlock()
{
clear
echo "!EXOTISTIC!" | figlet
if [ -f .LOCK ]; 
then
	echo -e "~!UNDER MAINTENANCE! Please try again later! You would not be able to login or register at the moment!~\n\n"
	mainscreen
else
	mainscreen
fi
}

#The main login screen
mainscreen()
{
	touch .infotable
	echo "Welcome to Exotistic! A brand known for wild delicacies!" 
	echo "Press R to Register."
	echo "Press L to Login."
	echo "Press E to Exit."
	echo -ne "\nYour selection: "
	read input1

	if [ $input1 = "e" ] || [ $input1 = "E" ];
			then
			clear
			echo "You have chosen to close the program." 
			sleep 2
			exit 1
	
	elif [ -f .LOCK ];
			then
			echo -e "~!UNDER MAINTENANCE PLEASE TRY AGAIN LATER!~"	
			sleep 3
			clear
	      		testforlock

	else
	case $input1 in
		R|r) 	clear
			echo "You have chosen to Register an account"
			bash register.sh
		;;
		L|l) 	clear
			echo "You have chosen to Login enter user login details below":
			bash login.sh
		;;		
		E|e) 	clear
			echo "You have chosen to close the program." 
			exec sleep 1
			exit
		;;
		*) 	clear
			echo "Invalid input. Program is now closing."
			exec sleep 1
			exit
		;;
	esac
	fi
}

#Calling of Functions
testforlock

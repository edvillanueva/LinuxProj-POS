#For deleting account that exists in the database
delacc()
{
echo "Account Deletion" | figlet
echo -n "You are about to delete your account! Are you sure? [y/n]: "
read key

	case $key in

	Y|y)	echo "You have chosen to delete your account with username: $uname"
		deleteme=$(cat .infotable | grep -oE "^$uname[^*]+")
		sed -i "/$deleteme/d" .infotable
		sleep 1
		echo "Account is now deleted! You'll be taken back to the main menu"
		sleep 1
		bash mp.sh
	;;
	N|n)	echo "You would now be taken back to the profile menu"
		bash profile.sh
	;;
	*)	echo "Invalid option! You'll be taken back to the main menu"
		bash mp.sh
	esac
}

#Calling of function
delacc

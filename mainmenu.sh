#Main menu of the machine problem / point of sales
mainmenu()
{
clear
echo "User menu" | figlet
echo -e "Welcome to Exotistic! The leading seller for unique delicacies around the globe!

Please select an option below!

a) Search
b) Highlights
c) New!
d) Cart 
e) Profile
f) About Us
g) Customer Care
h) Logout"

echo -ne "\nYour selection: "
read key
	case $key in

	A|a)	clear
		echo "You have chosen to browse our wide variety of exotic delicacies!"
		bash search.sh
	;;
	B|b)	clear
		echo "You'll now be browsing our highlighted goods!"
		sleep 1
		clear
		bash highlight.sh
	;;
	C|c)	clear
		echo "Looking for new products? You've chosen the right option!"
		sleep 1
		clear
		bash new.sh
		
	;;
	D|d)	clear
		echo "Want to check your cart? Do it here!"
		sleep 1
		clear		
		bash cart.sh
	;;
	E|e)	clear
		echo "Want to edit your profile? Check the configurations below!"
		export uname
		bash profile.sh
		
	;;
	F|f)	clear
		bash aboutus.sh
		mainmenu
	;;
	G|g)	clear
		bash customercare.sh
	
	;;
	H|h)	clear
		echo "Log out" | figlet
		echo "Logging out? Done shopping? Hope to see you soon again!"
		sleep 1
		echo "Returning to login screen"
		rm .cart
		bash mp.sh
	;;
	*)	clear
		echo "Invalid option selected! Please select from the menu!"
		sleep 1
		mainmenu
	;;
	esac
}

#Calling of the created functions is done here
mainmenu

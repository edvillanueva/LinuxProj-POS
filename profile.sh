#!/bin/bash
#Triggers when user would want to modify their profile information

#The main menu for selecting options
selection()
{
modme=$(cat .infotable | grep $uname)
#echo $modme

clear
display
echo "My Profile" | figlet
echo -e "You currently have the following information!

Username: $Username
User ID: $UserID
Full Name: $Fullname
Address: $Address
Email: $Email
Join Date: $Joined \n"

echo -e "What would you like to edit? 

a) Full name
b) Delivery Address
c) Email Address
d) Password
e) UID
f) Delete Account
g) Go Back to Main Menu \n"

echo -n "Your selection: "
read key
	case $key in

	A|a)	clear
		echo "You've chosen to change your full name!" 
		newname
	;;
	B|b)	clear
		echo "You've chosen to edit your delivery address!"
		newadd	
	;;
	C|c)	clear
		echo "You've chosen to edit your email address!"
		neweadd	
	;;
	D|d)	clear
		echo "You've chosen to edit your password!"
		newpass
	;;
	E|e)	clear
		echo "You've chosen to edit your UID!"
		newuid
	;;
	F|f)	clear
		echo -e "This is an irreversible process!\nDeleting your acct would remove you from the database!"
		bash deleteacc.sh
	;;
	G|g)	clear
		echo "Bringing you back to the main menu"
		sleep 1
		bash mainmenu.sh
	;;
	*)	clear
		echo "Invalid option! Please select from the menu"
	;;
	esac
}

#Function for showing all the information of the user
display()
{
Username=$(echo $modme | cut -f1 -d:)
UserID=$(echo $modme | cut -f2 -d:)
Fullname=$(echo $modme | cut -f4 -d:)
Address=$(echo $modme | cut -f5 -d:)
Email=$(echo $modme | cut -f6 -d:)
Joined=$(echo $modme | cut -f7 -d:)
}

#Function for changing the full name in the database
newname()
{
oldname=$(echo $modme | cut -f4 -d:)
echo "Your current name in your profile is \"$oldname\""
echo -n "Please enter the name you would like to change it to: "
read nname
sed -i "s/$oldname/$nname/g" .infotable
echo -e "Your name is now changed to \"$nname\""
echo "Press enter key to go back to Profile menu"
read enter
selection
#cat .infotable
}

#Function for changing the delivery address in the database
newadd()
{
oldadd=$(echo $modme | cut -f5 -d:)
echo "Your current address in your profile is \"$oldadd\""
echo -n "Please enter the new address you would like to change it to: "
read nadd
sed -i "s/$oldadd/$nadd/g" .infotable
echo -e "Your address is now changed to \"$nadd\""
echo "Press enter key to go back to Profile menu"
read enter
selection
}

#Function for changing the email address in the database
neweadd()
{
oldeadd=$(echo $modme | cut -f6 -d:)
echo "Your current email address in your profile is \"$oldeadd\""
echo -n "Please enter the new email add would like to change it to: "
read neadd
sed -i "s/$oldeadd/$neadd/g" .infotable
echo -e "Your email address is now changed to \"$neadd\""
echo "Press enter key to go back to Profile menu"
read enter
selection
}


#Function for changing the password of ADMINISTRATOR
adminnewpass()
{
if [[ -f .LOCK ]];
	then
	modme=$(cat .infotable | grep "0000" | cut -f3 -d:)
fi
echo "Changing password in administrator mode"
sleep 3
newpass
}

#Function for changing the password in the database
newpass()
{
oldencpass=$(echo $modme | cut -f3 -d:)
decoldpass=$(echo $oldencpass | openssl enc -base64 -d)
echo -ne "\nPlease enter your current password: "
read -s oldpw

	if [ $oldpw = $decoldpass ];
		then
			echo -ne "\nPlease enter your new password: "
			read -s newpw1
			echo -ne "\nPlease confirm your new password: "
			read -s newpw2
				if [ $newpw1 = $newpw2 ];
					then
						if [[ ${#newpw2} -lt "8" ]];
							then
							echo "\nPassword must be more than 8 characters!\n"
							newpass
						fi

					check=$(echo $newpw2 | grep [[:lower:]])
						if [[ $? -ne 0 ]];
							then
							echo -e "\nPassword must contain at least 1 lowercase char!\n"
							newpass
						fi

					check=$(echo $newpw2 | grep [[:upper:]])
						if [[ $? -ne 0 ]];
							then
							echo -e "\nPassword must contain at least 1 uppercase char!\n"
							newpass
						fi

					check=$(echo $newpw2 | grep [[:digit:]])
						if [[ $? -ne 0 ]];
							then
							echo -e "\nPassword must contain at least 1 Digit!\n"
							newpass
						fi

					check=$(echo $newpw2 | grep [[:punct:]])
						if [[ $? -ne 0 ]];
							then
							echo -e "\nPassword must contain at least 1 punctuation mark!\n"
							newpass
						fi
					
					newencpass=$(echo $newpw2 | openssl enc -base64)
					line=$(cat .infotable | nl | grep $uname | cut -f1 -d$'\t')
					cat .infotable | grep $uname > .toeditinfotable
					sed -i "$line"'d' .infotable
					sed -i "s/$oldencpass/$newencpass/g" .toeditinfotable
					cat .toeditinfotable >> .infotable
					rm .toeditinfotable			
					echo -e "\nYour password has been changed!"
					echo "Press enter to go back to prev menu!"
					read enter
	if [[ -f .LOCK ]]
	then
	#.adminpwreset is a file used to check date creation found in adminchangepass.sh
	echo "Your password timer is renewed to 30 days. Please change your password within 30 days or you'll be forced to."
	echo "Password was modified on "$(cat .adminlastchange)" and will expire on "$(cat .adminnextchange)""
	else
	selection
	fi
				else
				echo -e "\nPasswords don't match!\n"
				sleep 1				
				tryagain
				fi
		else
		echo -e "\nIncorrect password!"
		sleep 1
	fi
	tryagain
}

#Prompt for changing User ID
newuid()
{
olduid=$(echo $modme | cut -f2 -d:)
echo "The current user ID in your profile is \"$olduid\""
echo -n "Please enter the new user ID would like to change it to: "
read nuidd
	if (cat .infotable | cut -f2 | grep -q $nuidd);
	then echo "The UID you have chosen already exists! Please try something else."
	echo "Press enter key to go back to Profile menu"
	read enter
	selection
	else
	sed -i "s/$olduid/$nuidd/g" .infotable
	echo -e "Your user ID is now changed to \"$nuidd\""
	echo "Press enter key to go back to Profile menu"
	read enter
	selection
	unset olduid nuidd
	fi
}

#Prompt for reentering / trying again to change passwords
tryagain()
{
		clear
		echo -en "Try again (T)\nGo back to previous menu (G)\nYour selection: "
		read key
		case $key in

			T|t)	clear
				newpass
			;;
			G|g)	clear
				selection
			;;
			*)	clear
				echo "Invalid option. Try again!"
				tryagain
			;;
		esac
}

#calling of functions created
if [[ -f .LOCK ]];
	then
	adminnewpass
	else
	selection
fi

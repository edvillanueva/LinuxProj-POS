#!/bin/bash
#Acts as the login page
#Triggers when L or l is pressed on the main page

#User input of username
user_login()
{
echo "Login page" | figlet
echo "Usernames are non-case sensitive"
echo -n "Enter Username: "
read uname
#Check if login account is for administrator
	if [[ $(cut -f1 -d":" .infotable | grep -wi "$uname") = "administrator" ]];
	then
	echo "You are now to log in with an admin account."
	touch .LOCK
	sleep 1
	user_password
	else

#Check if username exists in database
uname=$(echo $uname | tr [:upper:] [:lower:])
		if [[ $(cut -f1 -d":" .infotable | grep -wi $uname) = "$uname" ]]
		then
		user_password
		else
		echo "Username does not exist in the database!"
		wrongprompt
		fi
	fi
return 0
}

#User input of password
user_password()
{

echo -en "Enter Password: "
read -s password
decpass
if [[ "$decpasswd" = "$password" ]]
then
		if [[ -f .LOCK ]]
		then
			if [ "$(date +%Y%m%d)" -ge "$(cat .adminnextchange)" ];
			then
				echo "Your account hasn't changed password in 30 days! Please change the password now!"
				sleep 3		
				bash adminchangepass.sh
			else
				echo "Login Successful"
				sleep 1	
				bash adminmenu.sh			
			fi
		else
		echo "Login Successful"
		sleep 1	
		clear
		export uname
		bash mainmenu.sh
		fi
else
rm -f .LOCK
wrongprompt
fi
}

#Decrypting the encrpyted password and storing it in a variable
decpass()
{
decpasswd=$(grep -w $uname .infotable | cut -f3 -d: | openssl enc -base64 -d)
return 0
#echo $decpasswd
}

#Asking of confirmation from user for wrong logins
wrongprompt()
{
echo -e "\n\nIncorrect Account Details!\n\nLogin again (L)\nRegister for an account(R)\nBack to Main Menu (M)\nExit Program (Any key)"
read key

        case $key in

        L|l)    clear
                user_login
        ;;
        M|m)    clear
                bash mp.sh
        ;;
        R|r)    clear
                echo "Taking you to the registration form"
                sleep 1
                bash register.sh
	;;
        *)      clear
                echo "You've chose to close the program."
                exec sleep 1
        ;;
	esac
}

#Calling of functions created
user_login

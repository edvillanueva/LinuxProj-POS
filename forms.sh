#Function Declarations are done here and they are called after they have been declared

#Input of Fullname of user
fullname_in()
{
	echo "Registration forms" | figlet
	echo -e "Input full name in the format (First name, Middle name, Last name): "
	read fullname
#Reads the input of the user then stores it as a fullname
	if [[ -z $fullname ]]
		then
		echo "Error in entering username. Try again!"
		fullname_in	
	fi
	echo $fullname > .fullname

return 0
}

#Input of Delivery Address of the user
delivery_in()
{
	echo -e "\nEnter Delivery Address (Max of 100 chars only)"
	read deliveryadd
	nosymbol=$(echo $deliveryadd | grep ":")
	if [[ $nosymbol = $deliveryadd ]]
		then
		echo "Please do not include colon (:) in your address!"
		delivery_in
	fi

	if [[ ${#deliveryadd} -gt 100 ]]
		then		
		echo "Error! Please try again, limit to address to less than 100 chars."
		delivery_in
	fi

	if [[ -z $deliveryadd ]]
		then
		echo "Error in expressing input. Please try again."
		delivery_in
	fi
	echo $deliveryadd > .deliveryadd

return 0
}

#Input of Email Address of the user
email_in()
{
	echo -e "\nPlease input your Email Address: "
	read emailadd
	if [[ -z $emailadd ]]
		then
		echo "Error in entering email add. Please try again."
		email_in
	fi

validcheck=$(echo $emailadd | grep "[[:alnum:]][[:alnum:]]*@*.com$")
	if [[ $validcheck != $emailadd ]]
		then
		echo "Not a valid email address! No domain found!" 
		email_in
	fi
	echo $emailadd > .emailadd
return 0
}

#Input of Username of the user
user_in()
{
echo -e "\nNote: Usernames are non-case sensitive."
echo -n "Enter Username (non-case sensitive): "
read username
	
	echo $username | tr [:upper:] [:lower:] > .username
	touch .infotable
	trusername=$(cat .username)
	x=$(cat .infotable | cut -f1 -d: | grep "$trusername")

	#To check if username is unique using -z test operand
	if [[ -z "$trusername" ]]
	then
	echo -n "Username must be unique! A similar username has been found."
	sleep 1
	user_in
	fi

	#To check if username has at least 8 characters in length
	echo $trusername > .regist.txt
	if [[ $(cut -f1 -d" " .regist.txt | wc -c) -lt "8" ]]
	then
	echo "The entered username is less than required min char. (8 chars)"
	sleep 1
	user_in
	fi

	#To check if username begins with an alphabetic character`
	echo $trusername | cut -c1 | grep -q [a-z,A-Z]
	if [[ $? -ne 0 ]]
	then
	echo "Username must begin with an Alphabetic character!"
	sleep 1
	user_in
	fi

	#To check if username is already in the database
	if [ "$x" = "$trusername" ];
	then 
	echo -e "\nUsername already exists!"
	sleep 1
	user_in
	fi

	#To check if username has special characters in it
	nosymbol=$(echo $username | grep "[[:punct:]]")
	if [[ $username = $nosymbol ]]
	then
	echo "Please do not include any special symbol!"
	user_in
	fi
	export $username

	#To check if the username would be created is for root
	if [ $username = "administrator" ];
	then
	touch .adminpwreset
	lastchange=$(stat .adminpwreset | grep "Modify" | cut -f2 -d" " | sed "s/-//g")
	nextchange=$(date --date="+30 days" +%Y%m%d)
	echo $lastchange > .adminlastchange
	echo $nextchange > .adminnextchange
	date --date="+30 days" +%Y-%m-%d > .displayexpirydate
	fi
	

}

#Function for generating UID of a specific user
uid_in()
{

if [ $username = "administrator" ];
	then
	uid="0000"
	else
	awk -v newUser="$(echo $username)" -f addUser.awk .infotable > .info && cat .info | grep $username > .masterdump && cat .masterdump | cut -f2 -d: > .uid

	uid=$(cat .uid)
	rm .info .masterdump 
fi
}

#Function for confirming the account details
confirmation()
{

clear
echo "Entering an invalid key would cause program to close!"
echo -n "Submit all information you have entered? [y/n]: "
read key
case $key in

	Y|y)	clear
		info_dump
		echo -e "Successfully created the account!\nInfo database was updated.\nA confirmation mail would be sent to $emailadd\nPress enter to go back to main menu."
		read enter
		bash mp.sh
	;;
	N|n)	clear
		echo -e "You've chosen not to register the account.
			\nNo account details was saved.
			\nPress enter to go back to main menu."
		rm .username .encpasswd .fullname .deliveryadd .emailadd
		read enter
		bash mp.sh

	;;
	*)	clear
		echo -e "INVALID OPTION.
			No account details was saved.
			Returning to the main menu"
		sleep 1
		bash mp.sh
		rm .username .encpasswd .fullname .deliveryadd .emailadd
		exec sleep 1
	;;
esac
}

#Function for determining when a username was created
datecreated()
{

stat .username > .datestamp
cat .datestamp | grep Modify | cut -f2 | cut -f2 -d" " > .dateregistered
dateregistered=$(cat .dateregistered)

}

#Combination of dumpfiles into a single file to show the information table
info_dump()
{

#Generate the information table (Initialize)
file=./.infotable
if [ ! -s $file ];
	then
	echo "Username:UID:Password:Full Name:Address:E-mail Add:Date Created" >> .infotable
fi

datecreated

encpasswd=$(cat .encpasswd)
echo "$trusername:$uid:$encpasswd:$fullname:$deliveryadd:$emailadd:$dateregistered" >> .infotable

#paste .username .uid .encpasswd .fullname .deliveryadd .emailadd .dateregistered -d ":" >> .infotable
rm -f .username .uid .encpasswd .fullname .deliveryadd .emailadd .dateregistered .datestamp .regist.txt

}

#Calling of functions that were created

clear
fullname_in
delivery_in
email_in
user_in
uid_in
#calling password.sh for password registration
export trusername 
bash password.sh
#confirming account details of user
confirmation
#sending an email of the completion of the account
export fullname deliveryadd emailadd trusername dateregistered
bash mail.sh

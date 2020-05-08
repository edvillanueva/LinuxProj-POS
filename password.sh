#!_!_!_!_!Input of Password of the user !_!_!_!_!
#Using -e for echo allows backslash to be used in passwords

pass_in()
{
echo "Password creation" | figlet
echo -e "\nGuidelines in creating a password:"
echo "At least 8 characters in length"
echo -e "Password must contain at least: \n " 
echo -e "1 Lower case \n1 Upper case \n1 Numerical char \n1 Punctuation mark\n Username should not be a part of password"
echo -e "\nEnter desired password: "
read -s passwd1
echo -e "Please confirm password: "
read -s passwd2
echo -e "\n"

#!!!To check if password is 8 characters or more:!!!

	echo $passwd2 > .charcheck.txt
	if [[ $(cut -f1 -d" " .charcheck.txt | wc -c ) -lt "8" ]]
		then
		clear
		echo -e "\nPassword entered is less than 8 characters!\n" 
	pass_in
	fi

#!!To check if password has a lowercase character!!
	guidecheck=$(echo $passwd2 | grep '[[:lower:]]')
		if [[ $? -ne 0 ]]
			then
			clear
			echo -e "\nPassword must contain at least 1 lowercase character!\n"
			pass_in
		fi

#!!To check if password has a uppercase character!!
	guidecheck=$(echo $passwd2 | grep '[[:upper:]]')
		if [[ $? -ne 0 ]]
			then
			clear
			echo -e "\nPassword must contain at least 1 uppercase character!\n"
			pass_in
		fi


#!!To check if password has a numerical character!!
	guidecheck=$(echo $passwd2 | grep '[[:digit:]]')
		if [[ $? -ne 0 ]]
			then
			clear
			echo -e "\nPassword must contain at least 1 Digit!\n"
			pass_in
		fi

#!!To check if password has a punctuation mark character!!
	guidecheck=$(echo $passwd2 | grep '[[:punct:]]')
		if [[ $? -ne 0 ]]
			then
			clear
			echo -e "\nPassword must contain at least 1 punctuation mark!\n"
			pass_in
		fi

#To check if password is a part of their username
	nodup=$(echo "$passwd2" | tr [:upper:] [:lower:] | tr -d [:punct:] | sed 's/[0-9]*//g')
		if [[ $nodup == *"$trusername"* ]]	
               	then
			clear
               	echo "Don't include username as a password! Choose something better!"
			pass_in
		else 
			encpasswd=$(echo $passwd2 | openssl enc -base64)
		fi

	echo $encpasswd > .encpasswd	
	rm .charcheck.txt
}

pass_in

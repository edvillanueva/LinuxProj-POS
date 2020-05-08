#!/bin/bash
#Triggers when the admin chooses to add an item to their database
#Prompt for admin to add items

#Adding of item based on uid
addnewitemID()
{
echo "Add item to DB" | figlet
echo "Please verify all details when entering them in the database"
newitemID=$(cat FirstDB.txt | cut -f1 -d: | 
      awk -F: '{a[$1+0]} $1>max{max=$1} 
      END {for(i=1;i<=NR;i++) if(!(i in a)) {print i; exit} 
      print max+1}')
newitemID=$(printf "%04d" $newitemID)
echo "Detected free item ID is: $newitemID"
addnewitemprompt
}

addnewitemprompt()
{
read -p "Enter item Short Name: " newitemshortname
read -p "Enter item Full Description: " newitemfulldesc
read -p "Quantity in stock: " newitemquant
read -p "Item retail price: " newitemprice
read -p "Item tag / keywords: (If multiple tags seperate by :) " newitemkeyword
touch .datestamp
dateadded=$(stat .datestamp | grep Modify | cut -f2 | cut -f2 -d" ") 
rm .datestamp

echo "$newitemID:$newitemshortname:$newitemquant:$newitemprice:$dateadded" >> FirstDB.txt
echo "$newitemID:$newitemfulldesc" >> SecondDB.txt
echo "$newitemID:$newitemkeyword" >> .ThirdDB.txt

cat FirstDB.txt | sort > FirstDB.txt.bak && mv FirstDB.txt.back FirstDB.txt
cat SecondDB.txt | sort > SecondDB.txt.bak && mv SecondDB.txt.back SecondDB.txt
cat .ThirdDB.txt | sort > .ThirdDB.txt.bak && mv .ThirdDB.txt.back .ThirdDB.txt

echo -n "All database has been updated! Add more items? [y/n]: "
read $ans

if [[ $ans = "y" ]] || [[ $ans = "Y" ]];
	then
		echo "Adding more items!"
		sleep 2
		clear
		addnewitemid
	else
		echo "Going back to admin menu"
		sleep 2
		bash adminmenu.sh
fi
}

#Check if item id already exists, if it does asks user to input another
checkitemid()
{
	if [ $(cat FirstDB.txt | cut -f1 -d: | grep "$newitemID") ];
	then
	echo -n "UID exists! Do you want to check the last 5 item id's that were used? [y/n]: "
	read yn
		if [ $yn = "y" ] || [ $yn = "Y" ];
		then
		cat FirstDB.txt | cut -f1 -d: | tail -5
		addnewitemID
		else
		addnewitemID
		fi
	else
	addnewitemprompt
	fi
}

#Calling of function
addnewitemID

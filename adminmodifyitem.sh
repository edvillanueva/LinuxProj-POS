#!/bin/bash
#Triggers when the administrator would like to edit or modify a certain item from the database

#Function for modifying items in database
adminmodify()
{
echo "Item modification" | figlet
rm -f .returntoparent
echo -n "Enter the ITEM ID that you would like to modify: "
read itemmodify

amodname=$(cat FirstDB.txt | grep $itemmodify | cut -f2 -d:)
amodquant=$(cat FirstDB.txt | grep $itemmodify | cut -f3 -d:)
amodprice=$(cat FirstDB.txt | grep $itemmodify | cut -f4 -d:)
amoddescrip=$(cat SecondDB.txt | grep $itemmodify | cut -f2 -d:)

echo -n "What do you wish to do with the item with ID $itemmodify and name $amodname? edit (e) | delete (d) | cancel (c): "
read rep
	case $rep in

E|e)	echo "You have chosen to edit the selected item with item ID $itemmodify"
	sleep 2
	modifyme ;;

D|d)	echo "You have chosen to delete the selected item with item ID $itemmodify and name $amodname"
	echo -n "Are you sure you would like to delete $amodname? [y/n]: "
	read yyy
		if [[ $yyy = y ]] || [[ $yyy = Y ]];
		then
			sed -i "/$itemmodify/d" FirstDB.txt
			sed -i "/$itemmodify/d" SecondDB.txt
			sed -i "/$itemmodify/d" .ThirdDB.txt
		echo "Item is now deleted in all databases!"
		else
			echo "You have chosen not to delete the item. You'll be taken back to the main menu."
			bash adminmenu.sh
		fi 
	;;

C|c)	echo "You have chosen to cancel. You will now be taken back to the main menu."
	bash adminmenu.sh;;

*)	echo "Invalid option selected! Try again!"
	adminmodify;;
	esac
}

#Searching on what to modify
whattomodify()
{
echo -n "View / Edit / Delete Items from the database (y) | back to admin menu (n) | Your selection: "
read xyx
	case $xyx in

	Y|y)	source search.sh
		search ;;

	N|n)	echo "You'll be taken back to the main menu"
		sleep 2
		bash adminmenu.sh ;;

	*)	echo "Invalid option selected! Please choose from the options."
		whattomodify ;;
	esac
}

#Prompt for when admin has selected something to modify 
modifyme()
{
echo "What would parameter would you like to modify?"
	echo -n "short name (s) | quantity (q) | retail price (r) | description (d) | go back to main menu (g): "
	read xxx
		case $xxx in
		
		S|s)	echo "Modifying short name!"
			echo -n "What would you like the new short name of $amodname to be?: "
			read modshortname
			sed -i  "s/$amodname/$modshortname/g" FirstDB.txt
			echo "Success! $amodname is now $modshortname in the database!"
			modifyme ;;

		Q|q)	echo "Modifying quantity!" 
			echo "We currently have $amodquant in our inventory"
			echo -n "What would be the new quantity of $amodname?: "
			read modquantity
			sed -i "s/$amodquant/$modquantity/g" FirstDB.txt
			echo "Success! $amodquant is now $modquantity in the database!"
			modifyme ;;

		R|r)	echo "Modifying retail price!"
			echo "The current retail price of $amodname is $amodprice"
			echo "What would you like to be it's new price?: "
			read modprice
			sed -i "s/$amodprice/$modprice/g" FirstDB.txt
			echo "Success! The price of $amodname is now $modprice which is previously $amodprice"
			modifyme ;;

		D|d)	echo "Modifying item description!"
			echo "The curent description of $amodname is $amoddescrip"
			echo -n "Please enter the new item description of $amodname: "
			read moddescrip
			echo "Success! The description of $amodname is now updated!" 
			modifyme;;

		G|g)	echo "Going back to the administrator menu"
			bash adminmenu.sh ;;
		*)	echo "Invalid option selected! Please try again!"
			modifyme	;;
		
		esac
}

#Checks if search was done and proceed with modification
if [[ -f .returntoparent ]];
then
adminmodify
fi

#Calling of functions
whattomodify

#!/bin/bash
#Triggers when an administrator chooses to modify the discount card parameters

discountmenu()
{
echo "Discount Cards" | figlet
echo "Modify discount cards here!"
echo -n "add discount card (a) | edit discount card (e) | delete discount card (d) | go back to admin menu (g) : "
read x
	case $x in

a|A)	clear
	echo "You have chosen to add a discount card!"
	sleep 1
	adddiscount
	;;

e|E) 	clear
	echo "You are now to edit available discount cards!"
	sleep 1
	#Insert edit discount card here
	;;

d|D)	clear
	echo "You have chosen the option to delete discount cards!"
	sleep 1
	#Insert delete function here
	;;

g|G)	clear
	echo "Returning now to admin menu!"
	sleep 1
	bash adminmenu.sh
	;;

*)	echo "Invalid selection! Please select a valid option."
	sleep 1
	discountmenu
	;;

	esac
}

adddiscount()
{
clear
touch .DiscountDB.txt
echo "Add discount cards here!"
i=0
while [ i=0 ]
do
echo -n "Enter Discount card name: "
read discountcard
	if [[ $(cat .DiscountDB.txt | cut -f1 -d: | grep "$discountcard") ]]
		then
		echo "Discount card exists! Please try something else."
		else
		break
	fi
done

a=0
while [ a=0 ]
do
echo -n "Enter Discount percentage rate: "
read discountrate
	if [[ $(echo $discountrate | grep [[:digit:]]) ]]
	then
		break
	else echo "Enter a valid number!"
	fi
done
echo -n "Enter Keywords affected by discount: "
read discountkeywords

echo -e "\nThe following information would be saved in the discount database"
echo "Please finalize the details!"
echo "Discount card name: $discountcard"
echo "Discount rate: $discountrate"
echo -e "Keywords affected by discount: $discountkeywords \n"

echo -e "Proceed in saving the information in the database? [y/n]: "
read res
	case $res in

y|Y)	echo "Saving the discount card in the discount database!"
#The 1 in the third column represents flag / active discount card // 0 for used or inactive 
	echo "$discountcard":"$discountrate":"valid":"$discountkeywords" >> .DiscountDB.txt
	echo "Discount card saved!"
	sleep 1
	echo "Going back to main menu!"
	bash adminmenu.sh	
;;

n|N)	echo "You have chosen not to save the information in the database. Going back to main menu."
	bash adminmenu.sh
;;

*)	echo "Invalid option selected, going back to main menu."
	bash adminmenu.sh
;;

	esac
}

#Invocation of menu
discountmenu

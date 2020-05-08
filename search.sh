#!/bin/bash
#Triggers when searching for items in the database
#Function for searching through the database

search()
{
echo "Product search" | figlet
if [ -f .highlightsearch ] || [ -f .newfinalformatted ];
then
	rm -f .highlightsearch .newfinalformatted
	searchselection
else
	echo -n "What are you trying to search for: "
	read searchme
	cat FirstDB.txt | grep -wi $searchme > .forfirdbhit
	cat SecondDB.txt | grep -wi $searchme > .forsecdbhit
	paste .forfirdbhit .forsecdbhit -d$'\n' > .alldbhit
	
	line=$(cat .alldbhit | wc -l)
	
	#Because of formating we need to check how many lines are there in the final output file .alldbhit	
	if [[ "$line" -ge "3" ]]
	then	
#If lines (UID) is more than 2. Trim last line for it's a duplicate description due to uniq and id of item descrip	
		cat .alldbhit | cut -f1 -d: | sort -n | uniq | sed '1d' > .idofnodup #All hits sorted and no unique instance
	else
#If lines (UID) is less than 2. The uniq command will automatically trim down the last duplicate hence leaving 1 uid
		cat .alldbhit | cut -f1 -d: | sort -n | uniq > .idofnodup
	fi

	cat FirstDB.txt | grep "$(cat .idofnodup)" | cut -f1 -d: > .idofresult
	cat FirstDB.txt | grep "$(cat .idofnodup)" | cut -f2 -d: > .nameofresult
	cat FirstDB.txt | grep "$(cat .idofnodup)" | cut -f3 -d: > .quantityofresult
	cat FirstDB.txt | grep "$(cat .idofnodup)" | cut -f4 -d: > .priceofresult
	cat SecondDB.txt | grep "$(cat .idofnodup)" | cut -f2 -d: > .descripofresult

		#SEARCH FUNCTION FOR WHEN ADMIN IS USING
		if [[ -f .LOCK ]];		
		then
		paste .idofresult .nameofresult .quantityofresult .priceofresult .descripofresult -d$'\t' > .finalsearchres
		cat .finalsearchres | column -ts $'\t' > .finalsearchres.tmp && mv .finalsearchres.tmp .finalsearchres
		echo -e "ID\tName\tQty\tPrice\tDescrip\n"		
		cat .finalsearchres
		echo -ne "\nResults found! "
			touch .returntoparent
		bash adminmodifyitem.sh
		return 0
		fi
		

		if [[ -s .idofnodup ]];
			then
				echo -e "\nSearch was able to find these results!\n"
				paste .idofresult .nameofresult .descripofresult -d$'\t' > .finalsearchres
		cat .finalsearchres | column -ts $'\t' > .finalsearchres.tmp && mv .finalsearchres.tmp .finalsearchres
				cat .finalsearchres
				echo -ne "\nResults found! "
				searchselection
			else
				echo -ne "\nNo results found! "
				searchselection
		fi
fi
}

#Function for letting the user select to search again or go back
searchselection()
{		
		echo -ne "\nGo to product search (y) | No, go to item selection (n) | Check cart (c) | go back to menu (g): " 	
		read key
			case $key in

		Y|y)	echo -e "Switching to product search!"
			search ;;

		N|n)	echo -e "\nProceeding to item selection"
			rm -f .highlightselect			
			selectitems ;;

		C|c)	echo -e "\nChecking cart!"
			sleep 1
			if [ ! -e .cart ];
				then
				echo "No items in cart yet! Search then add an item in your cart first!"
				searchselection
				else
				bash cart.sh
			fi ;;

		G|g)	echo -e "\nGoing back to the main menu"
			rm -f .highlightselect
			sleep 1
			bash mainmenu.sh ;;

		*)	echo -e "\nInvalid input! Please choose among the choices"
			searchselection ;;
			esac
}

#Function for selecting items that the user would want
selectitems()
{
echo -n "Select items that you would like to buy by entering product ID: "
read selected
if [[ $selected =~ ^[0-9]+$ ]]
        then
        cat "FirstDB.txt" | grep "$(echo $selected)" > .selresult
        cat .selresult | cut -f1 -d: > .selitemno1
        cat .selresult | cut -f2 -d: > .selshortname2
        echo -ne "How many of $(cat .selshortname2) would you like? "
        read quantity
                if [[ $quantity =~ ^[0-9]+$ ]]
                then
		echo "Updating cart!"                
		sleep 1
		echo "$(echo $quantity) of $(cat .selshortname2) was added to cart!"
		sleep 1
		clear

                else
                echo "Please input a numerical value!"
		selectitems
                fi
        		echo "$quantity" > .selquantity3
        		cat .selresult | cut -f4 -d: > .selprice4
        		q=$(cat .selquantity3)
        		p=$(cat .selprice4)
       		 	echo "$(($p*$q))" > .seltotal5
 			paste .selitemno1 .selshortname2 .selquantity3 .selprice4 .seltotal5 >> .cart
			column -s$'\t' -t .cart
			#cat .cart
			selselection
			
        else
        	echo "Invalid input! Please try again."
		selectitems
fi

if [[ $selected -eq 0 ]]
        then
        echo "Please enter a valid number!"
fi

#FILE CLEANUP GOES HERE +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rm -f .selresult .selitemno1 .selshortname2 .selquantity3 .selprice4 .seltotal5 
rm -f .sitemid1 .sshortname2 .result1 .result2 .results .description3
}

#Function for letting the user select to search again or go back
selselection()
{		
		echo -ne "\nAdd more items? yes (y) | no, go to cart (n) | search again (s) | go back to menu (g): " 	
		read key
			case $key in

		Y|y)	echo "Adding more items!"
			selectitems
		;;
		N|n)	echo "Proceeding to cart"
			bash cart.sh
		;;
		S|s)	echo "Searching again!"
			sleep 1
			search
		;;
		G|g)	echo "Going back to the main menu"
			sleep 1
			bash mainmenu.sh
		;;
		*)	echo "Invalid input! Please choose among the choices"
			selselection
		;;
			esac
}


#Calling of functions created
search
#FILE CLEANUP GOES HERE +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rm -f .selresult .selitemno1 .selshortname2 .selquantity3 .selprice4 .seltotal5 
rm -f .sitemid1 .sshortname2 .result1 .result2 .results .description3
exit


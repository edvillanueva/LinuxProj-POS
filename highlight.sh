#!/bin/bash
#Triggers when highlights / new option is selected

highlightsearch()
{
echo "Highlighted items" | figlet
if [[ ! -f .highlightterm ]]
	then
	echo "No highlights were set at the moment! Please come back later!"
	read -p "Press any key to go back to the main menu"
	bash mainmenu.sh
fi

highlightterm="$(cat .highlightterm)"
echo -e "In today's highlighted goods! We have items that are tagged as ["$highlightterm"]!\n"
highsearch=$(cat .ThirdDB.txt | grep -i "$highlightterm" | cut -f1 -d:)
cat FirstDB.txt | grep -i "$highsearch" > .highsearchres
cat .highsearchres | cut -f1 -d: > .highresult1 #itemid
cat .highsearchres | cut -f2 -d: > .highresult2 #itemname
cat SecondDB.txt | grep -i "$highsearch" | cut -f2 -d: > .highresult3 #itemdescription

paste .highresult1 .highresult2 .highresult3 > .highfinalres -d$'\t'
cat .highfinalres #finaloutput
rm -f .highsearchres .highresult1 .highresult2 .highresult3 .highfinalres
touch .highlightsearch .highlightselect
}

#Invoking the command
highlightsearch
	if [[ -f .LOCK ]]
	then
	echo -n "Reset the highlight term? (y) | Go back to admin menu (n):  "
	read yeno
		if [[ $yeno = "y" ]] || [[ $yeno = "Y" ]]
		then
		bash adminhighlight.sh
		elif [[ $yeno = "n" ]] || [[ $yeno = "N" ]]
		then
		bash adminmenu.sh
		else
		echo "Invalid option selected! Bringing you back to Admin menu."
		bash adminmenu.sh
		fi
	fi

source search.sh #Yung panggalingan ng cart
searchselection #Option to populate cart

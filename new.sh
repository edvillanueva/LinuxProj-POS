#!/bin/bash
#Triggers when new option is selected from the main menu
#Sorts the database according to when the item is added and outputs item added within the past 7 days

#Function for determining the files that were created 7 days ago
new()
{
echo "New items!" | figlet
for ((x=0 ; x<=7 ; x=x+1))
do
cat FirstDB.txt | grep $(date --date="$x days ago" +%Y-%m-%d) >> .newrange
cat .newrange | sort > .newrangesort
done

cat .newrangesort | cut -f1 -d: > .newid
cat .newrangesort | cut -f2 -d: > .newname
cat SecondDB.txt | grep "$(cat .newid)" | cut -f2 -d: >.newdescrip
paste .newid .newname .newdescrip -d$'\t' > .newfinal
cat .newfinal | column -ts $'\t' > .newfinalformatted
cat .newfinalformatted
rm -f .newid .newname .newdescrip .newrange .newfinal .newrangesort
}

#Calling of function created
new
source search.sh
searchselection

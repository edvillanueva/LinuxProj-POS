#!/bin/bash
#Triggers when customer uses the customer care page
echo "Customer Care" | figlet
echo "Because we care for our customers, we care for you!"
echo "Don't get lost in the program use this Customer Care page to make your shopping experience better!"
sleep 2
pg0=$(echo -e "\nThis is the first page of Customer care! You have reached the starting point.")
pg1=$(cat ".CustomerCarePg1" | fold -w 80 -s)
pg2=$(cat ".CustomerCarePg2" | fold -w 80 -s)
pg3=$(cat ".CustomerCarePg3" | fold -w 80 -s)
pg4=$(cat ".CustomerCarePg4" | fold -w 80 -s)
pg5=$(cat ".CustomerCarePg5" | fold -w 80 -s)
pg6=$(cat ".CustomerCarePg6" | fold -w 80 -s) 
pg7=$(cat ".CustomerCarePg7" | fold -w 80 -s)
pg8=$(cat ".CustomerCarePg8" | fold -w 80 -s)
pg9=$(cat ".CustomerCarePg9" | fold -w 80 -s)
pg10=$(echo -e "\nYou have reached the last page of Customer Care! Please go back to the main menu")
contact=$(cat ".CustomerCarePg10" | fold -w 80 -s)
declare -a manual=("$pg0" "$pg1" "$pg2" "$pg3" "$pg4" "$pg5" "$pg6" "$pg7" "$pg8" "$pg9" "$pg10")

promptchoice()
{
echo -e "\nPress the following keys to browse through this section!
1) Previous Page
2) Next Page
3) Contact Details
4) Back to main Menu"
echo -n "Your selection: "
}

pagearray()
{
x=0
clear
#promptchoice
#read a
while [ $x -lt "11" ]

do
promptchoice
read a    
    if [ $a -eq 1 -a $x -gt 0 ];
    then echo -e "${manual[$"x-1"]}\n"
    x=$(($x-1))
    

    elif [ $a -eq 2 -a $x -lt 10 ];
    then echo -e "${manual[$"x+1"]}\n" 
    x=$(($x+1))
    

    elif [ $a -eq 3 ];
    then echo -e "$contact\n"

    elif [ $a -eq 4 ];
    then bash mainmenu.sh

    else [ $a -eq * ];
    echo "Error in your input! Did you press previous despite not being on any page first?"
    echo "Or perhaps you went over the last page and still pressed next?"
    echo "Please try again!"
    sleep 3
    pagearray

if ($x = "11");
	then
	echo "You have seen the last customer care page! You will now be taken back to the prev menu."
	sleep 2
	pagearray
	fi

    fi

done
}

#calling of function
pagearray

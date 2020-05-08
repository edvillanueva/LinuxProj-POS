#!/bin/bash
#Triggers when admin has selected the "set highlights" function.

adminhighlight()
{
clear
	echo "Set highlights" | figlet
	if [[ -f .highlightterm ]]
	then echo "The highlight term that is currently set is ["$(cat .highlightterm)"]"
	fi
	echo -n "Would you like to set / overwrite a highlight (h) | delete the current one? (d) | back to admin menu (b): "
		read reply
		case $reply in

	H|h) 	echo "Set terms of highlights / tags that could be useful for customers."
		echo "Use the taste or food description that will show items that correspond to it."
		echo -n "Set the highlight term that would be showcased: "
		read highlightterm
		echo "$highlightterm" > .highlightterm
		echo "The highlight term that is currently set is ["$(cat .highlightterm)"] !"
		echo "Which will produce the following results:"
		source highlight.sh ;;


	D|d)	rm -f .highlightterm
		echo "The highlightterm is now deleted! Please set a new one or leave it empty."
		sleep 2
		adminhighlight ;;

	B|b)	echo "Going back to admin menu!"
		sleep 2
		bash adminmenu.sh ;;

	*)	echo "Invalid option selected! Please try again."
		adminhighlight ;;
		esac
}

#Invocation of the commands created
adminhighlight

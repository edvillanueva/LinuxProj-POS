#Registration Script
#To be triggered when user selects R or r in the initial case on mp.sh:

register()
{
echo "Account Registration" | figlet
echo -n "Press enter to continue"
read input
bash forms.sh
}

register
exit

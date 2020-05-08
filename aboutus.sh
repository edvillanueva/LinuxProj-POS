#Triggers when opening the "About Us" page on main menu.

AboutUs()
{
echo "About Us" | figlet
cat .AboutUs.txt | fold -w 80 -s
echo -e "\n"
read -n 1 -s -r -p "Press any key to go back to the main menu"
echo -e "\n"
}

AboutUs

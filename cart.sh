#Script for the cart of the user
#Displays the cart and the process inside it
cart()
{
clear
echo "Cart!" | figlet
cat .cart | cut -f1 -d$'\t' > .cartprodid1
#echo -e "\nTotal" >> .cartprodid1

cat .cart | cut -f2 -d$'\t' > .cartname2
cat .cart | cut -f3 -d$'\t' > .cartquant3
cat .cart | cut -f4 -d$'\t' > .cartquantotal4
cat .cart | cut -f5 -d$'\t' > .pricestoadd5

#cat .pricestoadd
awk '{ sum += $1 } END { print sum }' .pricestoadd5 > .totalprice
prices=$(cat .totalprice)

#Output cart with "Total price" appended
paste .cartprodid1 .cartname2 .cartquant3 .cartquantotal4 .pricestoadd5 > .finalcart
column -s$'\t' -t .finalcart > .displayfinalcart
echo -e "\nTotal: $prices php" > .displayfinalprice
cat .displayfinalcart .displayfinalprice > .totallyfinal
cat .totallyfinal

cartselection
}

#Modify or Remove items from cart
itemincart()
{
read -p "What's the item ID of the item you would like to modify/remove?: " productid
echo "What would you like to do with "$(cat .cart | grep $productid | cut -f2)""
echo -ne "\nModify quantity (m) | Remove from cart (r) | Cancel (x): "
read hit
	case $hit in

M|m)	echo "Modifying quantity!"
	read -p "Qty: " qty
		#Using awk to modify / populate cart
		awk -F"\t" -v "prodid=$productid" -v "qty=$qty" 'BEGIN{OFS=FS} 
		$1==prodid { $3=qty; $5=( qty * $4 ) }
		{print $0}' .cart > .cart.tmp && mv -f .cart.tmp .cart
	echo "Cart updated!"
	sleep 1
	cart
;;
R|r)	echo "Removing item from cart!"
	sleep 1
	sed -i "/$productid/d" .cart
	echo -ne "Cart has been updated!"
	cart
;;
X|x)	echo "Cancel was pressed! Going back to cart"
	cart
;;
esac
}

#Checkout for products
checkout()
{
echo -e "\nWelcome to the checkout panel please have your debit card or credit card ready for payment"
cardnum
cardexp
cardcvv
carddetails
}

#entering of card number
cardnum()
{
echo -n "Please enter your 16 digit card number: "
read cardnumber
echo $cardnumber > .cardnum
char=$(cat .cardnum | fold -w1 | wc -l)
rm .cardnum
	if (($char==16));
		then
			echo -n "Validating card number"
			sleep 1
			sortednum=$(echo $cardnumber | sed 's/\(....\)\(....\)\(....\)\(....\)/\1-\2-\3-\4/')
			echo -ne " the card number you entered is: $sortednum \n"
		else
			echo -ne "Invalid card number! Please check your card and try again.\n"
			cardnum
	fi
}

#entering of expiration date
cardexp()
{
echo -ne "\nPlease enter the expiration date found on your card with month and year: " 
read expdate
month=$(echo $expdate | cut -f1 -d"/")
year=$(echo $expdate | cut -f2 -d"/")
	if [[ 10#$month -le 10#12 ]] && [[ 10#$year -ge $(date | cut -f7 -d" " | cut -c3,4) ]];
		then
			echo -ne "Verifying expiration date"
			sleep 1
			echo -ne " expiration entered is $month/$year\n"
		else	
			echo "Invalid expiration date entered! Try a different card."
			cardexp
	fi
}

#Entering of CVV / VCC of card
cardcvv()
{
x=0
	while [ $x = 0 ]
	do
	echo -ne "\nEnter the 3 digits found at the back of your card: "
	read cvv
		if [ ${#cvv} -eq 3 ]
		then
		x=1
		else
		echo "CVV must exactly be 3 numbers! Please try again"
		fi
	done

	echo -ne "Verifying CVV "
	sleep 1
	echo -ne "the CVV entered is $cvv\n"
}

#Showing the complete details of the user and verifying payment
carddetails()
{
clear
echo "Please verify the following information are correct"
echo "Card number: $sortednum"
echo "Card expiration: "$month/$year""
echo "Card CVV: $cvv"
selcarddetails
}

#update stock inventory
updatestock()
{
awk -f updatestock.awk .cart FirstDB.txt > FirstDB.txt.tmp && mv FirstDB.txt.tmp FirstDB.txt
sed 
}

#promo code validation
promo()
{
totalprice=$(cat .totalprice)
echo -ne "Please enter promo code / discount card: "
read promocode
	#code validation if user already has one
	if [ -f .discountedTP ];
		then
		echo "You can't use two promotions at the same time! Please proceed to payment panel."
		selcarddetails
	fi
	
	#actual promocode hardcoded (to be changed by admin / sudo)
	if [[ $(cat .DiscountDB.txt | cut -f1 -d: | grep -w "$promocode") ]]
		then
		echo "You have entered a promo code that exist!"
		echo "Promo code name: $promocode"
		promorate=$(cat .DiscountDB.txt | grep "$promocode" | cut -f2 -d:)
		echo "Promo code / coupon percentage: "$promorate""
		promotag=$(cat .DiscountDB.txt | grep "$promocode" | cut -f4- -d: | sed -s "s/:/ /g")
		echo "Effective on item/s tagged as: $promotag"
		validity=$(cat .DiscountDB.txt | grep "$promocode" | cut -f3 -d:)
		echo "Validity: $validity"

		if [[ $validity = "invalid" ]]
			then
			echo "The promo card that you have entered is already used! Please try something else."
			read -n 1 -s -r -p "Press any key to go back to the prev menu"
			selcarddetails
		fi

		discountedkeywords=$(cat ".DiscountDB.txt" | cut -f4- -d:)
		discountedUIDs=$(cat ".ThirdDB.txt" | grep -i "$discountedkeywords" | cut -f1 -d:)
		cat ".ThirdDB.txt" | grep -i "$discountedUIDs" > .discounteditems
		cat .discounteditems | sed -s "s/ /\n/g" > .formatdiscounteditems
		rm .discounteditems 
		discounteduidincart=$(cat .formatdiscounteditems | cut -f1 -d:)
		#Conversion of multiple uids that can be grep'd in multiple patterns using \|		
		grepdiscounted=$(echo $discounteduidincart | sed -s "s/ /\\\|/g")
		discountedcartitems=$(cat .cart | grep "$grepdiscounted")
		#Responsible in getting the line that will be affected by sed
		flagchangesed=$(nl .DiscountDB.txt | grep $promocode | cut -f1 | sed -s "s/ //g")
		#Modification of used flag
	cat .DiscountDB.txt | sed -s ""$flagchangesed"s/valid/invalid/g" > .DiscountDB.txt.tmp && mv .DiscountDB.txt.tmp .DiscountDB.txt

		echo -e "\nResults for discount eligibility! \n"
		echo "$discountedcartitems"

		if [[ "$(echo $discountedcartitems | wc -l)" = 0 ]]
			then
			echo -e "\nNo items in your cart eligible for discounts!"
			read -n 1 -s -r -p "Press any key to continue"			
			else
			echo -e "\nSome items in your cart are eligible for discounts!"
			read -n 1 -s -r -p "Press any key to continue"
		fi

#INSERT PROMO CALCULATIONS HERE
#INSERT PROMO CALCULATIONS HERE
#INSERT PROMO CALCULATIONS HERE
#INSERT PROMO CALCULATIONS HERE
#INSERT PROMO CALCULATIONS HERE
#INSERT PROMO CALCULATIONS HERE
		tobediscounted=$(echo "$discountedcartitems" | rev | cut -f2 -d$'\t' | rev)
		echo "$tobediscounted" > .tobediscounted
		echo -e "\nBecause of discount eligibility, the total price would be decreased by $tobediscounted php"
		awk '{s+=$1} END {print s}' .tobediscounted > .discounted
		sumoftobediscounted=$(cat .discounted)
		rm .discounted
		#Added total items to be discounted then multiply to discount rate   
		totaldiscount=$(echo $sumoftobediscounted*0.$promorate | bc)
		newtotal=$(echo $prices-$totaldiscount | bc)
		echo "The new total price would be $newtotal!"
		touch .discountedTP
		selcarddetails

	else
		echo "Error code invalid! Taking you back to the previous menu."
		sleep 1
		selcarddetails
	fi
}
#Card selection after 
selcarddetails()
{
echo -ne "Proceed with payment (p) | re-enter card details (r) | enter promo code / discount card (c): "
read answer
	case $answer in

P|p)	clear
	echo "Proceeding with payment!"
	echo -e "Listed below are the items you have purchased\n"
	sleep 1
	#cat .totallyfinal
	sed 's/Total/Final Price/g' .totallyfinal

		if [ -f .discountedTP ]
		then
		echo "The new price would be $newtotal! This would be charged instead of "$prices" giving you $totaldiscount php discount!"
		fi

	echo -e "\nThank you for making the purchase! We hope you enjoy the products."
	read -n 1 -s -r -p "Press any key to go back to the main menu"
	updatestock	
	rm .cart .discountedTP
	unset discountedTP
	bash mainmenu.sh
	
;;
R|r)	echo "Re-entering card details!"
	sleep 1
	checkout
;;
C|c)	echo "You have chosen to enter a promo code / discount card!" 
	sleep 1
	promo

;;
*)	echo "Please enter a choice from the options above"
	sleep 1
	selcarddetails 	
;;
esac
}



#Selection prompt for user
cartselection()
{

echo -ne "\nFinalized orders? Check out (c) | Select item from cart (i) | Search again (s) | Highlights (h) | Main menu (m): "
read key
	case $key in

C|c)	echo "Checking out!"
	sleep 1
	checkout
;;
M|m)	echo "Going back to the main menu"
	sleep 1
	bash mainmenu.sh
;;
S|s)	echo -e "Proceeding to search"
	sleep 1
	bash search.sh
;;
H|h)	echo -e "Going to "Highlights"!"
	bash highlight.sh
;;
I|i)	echo "Selecting items from cart!"
	itemincart
;;

*)	echo "Invalid option selected! Please choose from one of the choices."
	cartselection
;;
esac

}

#Calling of functions created
cart
rm -f .cartprodid1 .cartname2 .cartquant3 .cartquantotal4 .pricestoadd5 
rm -f .totalprice .displayfinalcart .displayfinalprice

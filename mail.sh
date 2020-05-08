#Script that runs to send mail to newly created users

echo -e "Thanks for registering in Exotistic! The leading reseller for exotic food from around the world! This is an automated mail sent out to newly registered customers!

You have registered with the following information:

Username: $trusername
Name: $fullname
House address: $deliveryadd
E-mail address: $emailadd
Date Registered: $dateregistered

Hopefully you have fun browsing our wide selection of truly unique delicacies!
Feel free to message me if you have any suggestions or inquiries

-Gifter Villanueva" | mail -s "Registration Confirmation!" $emailadd

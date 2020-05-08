#!/bin/bash
#Triggers when an administrator would want to change their password

echo "change password" | figlet
touch .adminpwreset
lastchange=$(stat .adminpwreset | grep "Modify" | cut -f2 -d" " | sed "s/-//g")
nextchange=$(date --date="+30 days" +%Y%m%d)
echo $lastchange > .adminlastchange
echo $nextchange > .adminnextchange

source profile.sh
adminnewpass


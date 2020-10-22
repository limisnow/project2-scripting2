#!/bin/bash

#Check For Root
if [ "$EUID" != 0 ]; then
  echo "Must Run As Root"
  exit
fi

#Get Emails from Email text file
while IFS=, read -r line; do
  email="$line"
 #Generate Username and Password
  username=$(echo $line | cut -d"@" -f1)
  password=$(openssl rand -base64 12)

 #Check if User Exists
  egrep "^$username" /etc/passwd >/dev/null
  if [ $? -eq 0 ]; then
    echo -e "${password}\n${password}" | passwd ${username} 
    echo ${password}
  else
   #Create User and send email with account info
    useradd -m -p "$password" "$username"
    echo "User has been added to the system"
    echo "${username}: ${password}"
   ### echo "Dear ${username}, Your account has been created. Your password is ${password}." | sendmail -s 'Account Created' ${email}
  fi 
done < emails.txt

#Get Username and Create Password

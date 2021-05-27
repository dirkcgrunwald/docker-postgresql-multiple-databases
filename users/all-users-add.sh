#!/bin/sh
#
# Test named database for GIS sections
#

while IFS= read -r dbuser; do
  echo "dbuser is $dbuser"
  read -r dbpasswd
  echo "dbpasswd is $dbpasswd"
  ./single-user-add.sh $dbuser $dbpasswd
done < users.txt

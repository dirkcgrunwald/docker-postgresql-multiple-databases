#!/bin/sh
#
# Test named database for GIS sections
#

while IFS= read -r dbuser; do
  echo "dbuser is $dbuser"
  read -r PGPASSWORD
  echo "dbpasswd is $PGPASSWORD"
  psql postgresql://$dbuser:$PGPASSWORD@localhost/$dbuser <<EOF
    SELECT postgis_full_version();
    DROP TABLE IF EXISTS states;
    CREATE TABLE states
	(
	  name character varying(50),
	  geom geography
	);
EOF
done < users/users.txt

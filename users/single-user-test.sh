#!/bin/sh
#
# Test named database for GIS sections
#

export dbuser=$1
export dbpasswd=$2
  echo "dbuser is $dbuser"
  echo "dbpasswd is $dbpasswd"
  psql postgresql://$dbuser:$dbpasswd@localhost/$dbuser <<EOF
    \dn.
    \dt.
    SELECT postgis_full_version();
    DROP TABLE IF EXISTS states;
    CREATE TABLE states
	(
	  name character varying(50),
	  geom geography
	);
EOF

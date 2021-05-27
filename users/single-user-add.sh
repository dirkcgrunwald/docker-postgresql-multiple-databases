#!/bin/sh
#
# Test named database for GIS sections
#

export POSTGRES_USER=${POSTGRES_USER:-myapp}
export PGPASSWORD=${PGPASSWORD:-changeme}

export dbuser=$1
export dbpasswd=$2

echo "dbuser is $dbuser"
echo "dbpasswd is $dbpasswd"

psql postgresql://$POSTGRES_USER:$PGPASSWORD@localhost <<EOSQL1
               CREATE USER $dbuser PASSWORD '$dbpasswd';
               CREATE DATABASE $dbuser;
               GRANT ALL PRIVILEGES ON DATABASE $dbuser TO $dbuser;
EOSQL1

psql postgresql://$POSTGRES_USER:$PGPASSWORD@localhost/$dbuser <<EOSQL2
               CREATE EXTENSION postgis;
               CREATE EXTENSION postgis_topology;
\dn.
\dt.
               GRANT ALL PRIVILEGES ON SCHEMA topology TO $dbuser;
EOSQL2

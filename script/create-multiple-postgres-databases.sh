#
# The following script uses the user and password information
# in file /opt-users/users.txt to to create a database per user,
# set the password for that database and then initialize the postgis
# extensions.
#
# The user file shoudl contain pairs of lines that are the user and password.
# e.g.
#  user1
#  passwd1
#  user2
#  passwd2
#

set -e
set -u

while IFS= read -r dbuser; do
  echo "dbuser is $dbuser"
  read -r dbpasswd
  echo "dbpasswd is $dbpasswd"
  echo "  Creating user and database '$dbuser'"

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL1
               CREATE USER $dbuser PASSWORD '$dbpasswd';
               CREATE DATABASE $dbuser;
               GRANT ALL PRIVILEGES ON DATABASE $dbuser TO $dbuser;
EOSQL1

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" $dbuser <<-EOSQL2
               CREATE EXTENSION postgis;
               CREATE EXTENSION postgis_topology;
\dn.
\dt.
               GRANT ALL PRIVILEGES ON SCHEMA topology TO $dbuser;
EOSQL2

done < /opt-users/users.txt

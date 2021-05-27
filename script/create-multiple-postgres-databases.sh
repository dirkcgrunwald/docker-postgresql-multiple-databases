#

echo "Hi mom!"

set -e
set -u

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
            echo "  Creating user and database '$db'"
            echo psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
               CREATE USER $db;
               CREATE DATABASE $db;
               GRANT ALL PRIVILEGES ON DATABASE $db TO $db;
EOSQL

	done
	echo "Multiple databases created"
fi

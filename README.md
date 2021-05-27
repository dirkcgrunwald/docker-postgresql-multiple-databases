# Using multiple databases with the official PostgreSQL Docker image

This directory contains a script to create multiple databases using that
mechanism.

The following script uses the user and password information
in file ./users/users.txt to to create a database per user,
set the password for that database and then initialize the postgis
extensions.

The user file should contain pairs of lines that are the user and password.
e.g.
```
user1
passwd1
user2
passwd2
```


## Usage

* Create a directory 'dbdata' - if you need to re-create it, note that you'll need to use sudo
  so `sudo rm -rf ./dbdata ; mkdir dbdata` is useful

* Run `docker-compose up`

This should create two database with output similar to:
```
myapp-postgresql_1  | /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/create-multiple-postgres-databases.sh
myapp-postgresql_1  | dbuser is db1
myapp-postgresql_1  | dbpasswd is db1passwd
myapp-postgresql_1  |   Creating user and database 'db1'
myapp-postgresql_1  | CREATE ROLE
myapp-postgresql_1  | CREATE DATABASE
myapp-postgresql_1  | GRANT
myapp-postgresql_1  | CREATE EXTENSION
myapp-postgresql_1  | CREATE EXTENSION
myapp-postgresql_1  |  List of schemas
myapp-postgresql_1  |    Name   | Owner 
myapp-postgresql_1  | ----------+-------
myapp-postgresql_1  |  public   | myapp
myapp-postgresql_1  |  topology | myapp
myapp-postgresql_1  | (2 rows)
myapp-postgresql_1  | 
myapp-postgresql_1  |              List of relations
myapp-postgresql_1  |   Schema  |      Name       | Type  | Owner 
myapp-postgresql_1  | ----------+-----------------+-------+-------
myapp-postgresql_1  |  public   | spatial_ref_sys | table | myapp
myapp-postgresql_1  |  topology | layer           | table | myapp
myapp-postgresql_1  |  topology | topology        | table | myapp
myapp-postgresql_1  | (3 rows)
myapp-postgresql_1  | 
myapp-postgresql_1  | GRANT
myapp-postgresql_1  | dbuser is db2
myapp-postgresql_1  | dbpasswd is someother
myapp-postgresql_1  |   Creating user and database 'db2'
myapp-postgresql_1  | CREATE ROLE
myapp-postgresql_1  | CREATE DATABASE
myapp-postgresql_1  | GRANT
myapp-postgresql_1  | CREATE EXTENSION
myapp-postgresql_1  | CREATE EXTENSION
myapp-postgresql_1  |  List of schemas
myapp-postgresql_1  |    Name   | Owner 
myapp-postgresql_1  | ----------+-------
myapp-postgresql_1  |  public   | myapp
myapp-postgresql_1  |  topology | myapp
myapp-postgresql_1  | (2 rows)
myapp-postgresql_1  | 
myapp-postgresql_1  |              List of relations
myapp-postgresql_1  |   Schema  |      Name       | Type  | Owner 
myapp-postgresql_1  | ----------+-----------------+-------+-------
myapp-postgresql_1  |  public   | spatial_ref_sys | table | myapp
myapp-postgresql_1  |  topology | layer           | table | myapp
myapp-postgresql_1  |  topology | topology        | table | myapp
myapp-postgresql_1  | (3 rows)
myapp-postgresql_1  | 
myapp-postgresql_1  | GRANT
```

## Test it out

The script `./test-db-for-gis.sh` will loop through each user and question run postgres_version() to
insure that the postgis extensions are installed. It will also create a table that uses a `GEOM`
type which would fail if postgis is not setup correctly.

```
beast-18$ ./test-db-for-gis.sh
dbuser is db1
dbpasswd is db1passwd
                                                                                              postgis_full_version
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 POSTGIS="3.1.1 aaf4c79" [EXTENSION] PGSQL="130" GEOS="3.7.1-CAPI-1.11.1 27a5e771" PROJ="Rel. 5.2.0, September 15th, 2018" LIBXML="2.9.4" LIBJSON="0.12.1" LIBPROTOBUF="1.3.1" WAGYU="0.5.0 (Internal)" TOPOLOGY
(1 row)

dbuser is db2
dbpasswd is someother
                                                                                              postgis_full_version
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 POSTGIS="3.1.1 aaf4c79" [EXTENSION] PGSQL="130" GEOS="3.7.1-CAPI-1.11.1 27a5e771" PROJ="Rel. 5.2.0, September 15th, 2018" LIBXML="2.9.4" LIBJSON="0.12.1" LIBPROTOBUF="1.3.1" WAGYU="0.5.0 (Internal)" TOPOLOGY
(1 row)
```

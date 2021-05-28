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

This should create the default databases (and one called `myapp` with the configuration as is).

Then, run `users/all-users-add.sh` and it will add databases for individual users.
You can run that multiple times (e.g. if you decide to add a new user).

The resulting set of databases can be listed by connecting and using `\list`:


```
$ psql postgresql://myapp:changeme@localhost

myapp=# \list
                                 List of databases
       Name       | Owner | Encoding |  Collate   |   Ctype    | Access privileges
------------------+-------+----------+------------+------------+-------------------
 alice            | myapp | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/myapp        +
                  |       |          |            |            | myapp=CTc/myapp  +
                  |       |          |            |            | db1=CTc/myapp
 bob              | myapp | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/myapp        +
                  |       |          |            |            | myapp=CTc/myapp  +
                  |       |          |            |            | db2=CTc/myapp
 myapp            | myapp | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres         | myapp | UTF8     | en_US.utf8 | en_US.utf8 |
 template0        | myapp | UTF8     | en_US.utf8 | en_US.utf8 | =c/myapp         +
                  |       |          |            |            | myapp=CTc/myapp
 template1        | myapp | UTF8     | en_US.utf8 | en_US.utf8 | =c/myapp         +
                  |       |          |            |            | myapp=CTc/myapp
 template_postgis | myapp | UTF8     | en_US.utf8 | en_US.utf8 |
(7 rows)

myapp=# \q
```

## Test it out

The script `./users/all-users-test.sh` will loop through each user and question run postgres_version() to
insure that the postgis extensions are installed. It will also create a table that uses a `GEOM`
type which would fail if postgis is not setup correctly.

```
beast-61$ ./all-users-test.sh
Databases are...
                                 List of databases
       Name       | Owner | Encoding |  Collate   |   Ctype    | Access privileges
------------------+-------+----------+------------+------------+-------------------
 alice            | myapp | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/myapp        +
                  |       |          |            |            | myapp=CTc/myapp  +
                  |       |          |            |            | alice=CTc/myapp
 bob              | myapp | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/myapp        +
                  |       |          |            |            | myapp=CTc/myapp  +
                  |       |          |            |            | bob=CTc/myapp
 myapp            | myapp | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres         | myapp | UTF8     | en_US.utf8 | en_US.utf8 |
 template0        | myapp | UTF8     | en_US.utf8 | en_US.utf8 | =c/myapp         +
                  |       |          |            |            | myapp=CTc/myapp
 template1        | myapp | UTF8     | en_US.utf8 | en_US.utf8 | =c/myapp         +
                  |       |          |            |            | myapp=CTc/myapp
 template_postgis | myapp | UTF8     | en_US.utf8 | en_US.utf8 |
(7 rows)

dbuser is alice
dbpasswd is alicePassword
dbuser is alice
dbpasswd is alicePassword
 List of schemas
   Name   | Owner
----------+-------
 public   | myapp
 topology | myapp
(2 rows)

             List of relations
  Schema  |      Name       | Type  | Owner
----------+-----------------+-------+-------
 public   | spatial_ref_sys | table | myapp
 public   | states          | table | alice
 topology | layer           | table | myapp
 topology | topology        | table | myapp
(4 rows)

                                                                                              postgis_full_version
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 POSTGIS="3.1.1 aaf4c79" [EXTENSION] PGSQL="130" GEOS="3.7.1-CAPI-1.11.1 27a5e771" PROJ="Rel. 5.2.0, September 15th, 2018" LIBXML="2.9.4" LIBJSON="0.12.1" LIBPROTOBUF="1.3.1" WAGYU="0.5.0 (Internal)" TOPOLOGY
(1 row)

DROP TABLE
CREATE TABLE
dbuser is bob
dbpasswd is bobPassword
dbuser is bob
dbpasswd is bobPassword
 List of schemas
   Name   | Owner
----------+-------
 public   | myapp
 topology | myapp
(2 rows)

             List of relations
  Schema  |      Name       | Type  | Owner
----------+-----------------+-------+-------
 public   | spatial_ref_sys | table | myapp
 public   | states          | table | bob
 topology | layer           | table | myapp
 topology | topology        | table | myapp
(4 rows)

                                                                                              postgis_full_version
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 POSTGIS="3.1.1 aaf4c79" [EXTENSION] PGSQL="130" GEOS="3.7.1-CAPI-1.11.1 27a5e771" PROJ="Rel. 5.2.0, September 15th, 2018" LIBXML="2.9.4" LIBJSON="0.12.1" LIBPROTOBUF="1.3.1" WAGYU="0.5.0 (Internal)" TOPOLOGY
(1 row)

DROP TABLE
CREATE TABLE
```

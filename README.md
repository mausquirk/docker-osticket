osTicket
========

How to use this docker?
-----------------------

Copy docker-compose.yml file and change following parameters:
 - `MYSQL_ROOT_PASSWORD` - MySQL root password ,
 - `MYSQL_DATABASE` - name of **osTicket** database
 - `MYSQL_USER` - name of MySQL user used by **osTicket**,
 - `MYSQL_PASSWORD` - password for `MYSQL_USER`.

Then build *docker containers* via following command

    docker-compose up -d

In your web-browser open [http://localhost:3003](http://localhost:3003) page and finalize **osTicket** configuration.

Within *Database Settings* sectuon please put following values:

 - MySQL Table Prefix - `ost_`,
 - MySQL Hostname - `mysql`,
 - MySQL Database - this same as defined by `MYSQL_DATABASE` in docker-compose.yml file,
 - MySQL Username - this same as defined by `MYSQL_USER` in docker-compose.yml file,
 - MySQL Password - this same as defined by `MYSQL_PASSWORD` in docker-compose.yml file.
  
Post-install
------------

After **osTicket** setup please delete `/var/www/html/setup/` directory as suggested by **osTicket** warning.


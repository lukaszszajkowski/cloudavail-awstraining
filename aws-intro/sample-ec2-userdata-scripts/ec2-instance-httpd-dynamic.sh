#!/bin/bash
#the script below builds a server utilizing Amazon Linux, Apache, MySQL and PHP

#myapp - web server install 
#note: do not specify architecture dependent binaries in installer scripts
yum -y install httpd mysql php php-mysql

#myapp - mysql server install
#note: the mysql server install will be removed 
yum -y install mysql-server
#starts mysql server
service mysqld restart

#myapp - apache configuration
#note on apache configuration: any file placed in the directory /etc/httpd/conf.d/ will be read on apache start/restart - an ideal use case would be to create multiple files in this directory, with each file corresponding to a single vhost and one single file for global configuration
cat > /etc/httpd/conf.d/myapp.conf <<EOF
SetEnv MYAPP_DB_HOST localhost
SetEnv MYAPP_DB_USER myuser
SetEnv MYAPP_DB_PASS mypass
SetEnv MYAPP_DB_SCHEMA mydb
SetEnv MYAPP_DB_PORT 3306
EOF

#myapp - mysql configuration
mysql -h localhost -u root -e "CREATE USER 'myuser'@'%' IDENTIFIED BY 'mypass';"
mysql -h localhost -u root -e "GRANT ALL PRIVILEGES ON mydb.* TO 'myuser'@'%';"

#myapp - database content
#notes - this will eventually be moved into RDS and this code removed from userdata
##cats out database content
cat > /var/tmp/mydb.content.sql <<EOF
use mydb;
CREATE TABLE mlbstandings(id INT NOT NULL AUTO_INCREMENT,PRIMARY KEY(id),team VARCHAR(30),wins INT, losses INT);
INSERT INTO mlbstandings (team, wins, losses) VALUES('San Francisco Giants','94','68');
INSERT INTO mlbstandings (team, wins, losses) VALUES('Los Angeles Dodgers','86','76');
EOF
##loads database content
mysql -h localhost -u root -e "CREATE DATABASE mydb;"
mysql -h localhost -u root < /var/tmp/mydb.content.sql

#myapp - site content
#note - site content is typically gotten from a version control system, an artifact or pushed to server from a build/release/deploy tool
cat > /var/www/html/index.php <<EOF
<?php
// Make a MySQL Connection
mysql_connect("localhost", "root", "") or die(mysql_error());
mysql_select_db("mydb") or die(mysql_error());

// Retrieve all the data from the "mlbstandings" table
\$result = mysql_query("SELECT * FROM mlbstandings;")
or die(mysql_error());  

// store the record of the "example" table into $row
\$row = mysql_fetch_array( \$result );
// Print out the contents of the entry 

echo "Team: ".\$row['team']." ";
echo "Wins: ".\$row['wins']." ";
echo "Losses: ".\$row['losses']." ";
?>
EOF

#restarts apache/httpd
service httpd restart
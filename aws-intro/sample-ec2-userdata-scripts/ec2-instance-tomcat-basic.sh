#!/bin/bash
#the script below builds a server utilizing Amazon Linux and Tomcat7

yum -y install tomcat7

cd /usr/share/lib/tomcat7/webapps/
wget http://tomcat.apache.org/tomcat-5.5-doc/appdev/sample/sample.war

service tomcat7 restart

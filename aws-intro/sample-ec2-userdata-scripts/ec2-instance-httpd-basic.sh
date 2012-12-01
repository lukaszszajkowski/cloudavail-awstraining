#!/bin/bash
#the script below builds a server utilizing Amazon Linux, Apache, MySQL and PHP

#myapp - web server install 
#note: do not specify architecture dependent binaries in installer scripts
yum -y install httpd

cat > /var/www/html/index.html <<EOF
<html>
<head>
</head>
<body>
<h1>Hello, World!</h1>
</body>
</html>
EOF

#restarts apache/httpd
service httpd restart
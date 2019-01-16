#!/bin/bash
yum install -y httpd
echo "subnet for Firewall: ${firewall_subnets}" >> /var/www/html/index.html #because it's a template file, terraform will proper see the firewall_subnets 
service httpd start
chkconfig httpd on
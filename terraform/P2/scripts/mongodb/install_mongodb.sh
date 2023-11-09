#!/bin/bash

# Configure the package management system
sudo touch /etc/yum.repos.d/mongodb-org-7.0.repo

sudo echo "[mongodb-org-7.0]" >> /etc/yum.repos.d/mongodb-org-7.0.repo
sudo echo "name=MongoDB Repository" >> /etc/yum.repos.d/mongodb-org-7.0.repo
sudo echo "baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/" >> /etc/yum.repos.d/mongodb-org-7.0.repo
sudo echo "gpgcheck=1" >> /etc/yum.repos.d/mongodb-org-7.0.repo
sudo echo "enabled=1" >> /etc/yum.repos.d/mongodb-org-7.0.repo
sudo echo "gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc" >> /etc/yum.repos.d/mongodb-org-7.0.repo

sudo yum install -y mongodb-org

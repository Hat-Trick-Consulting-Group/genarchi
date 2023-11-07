#!/bin/bash

sudo systemctl status mongod
sudo cp -rf ./mongod.conf /etc/
sudo systemctl start mongod

# load configuration
# sudo mongosh --file setup_db.js

# mongodb commands

# sudo systemctl start mongod
# sudo systemctl status mongod
# sudo systemctl enable mongod
# sudo systemctl stop mongod
# sudo systemctl restart mongod

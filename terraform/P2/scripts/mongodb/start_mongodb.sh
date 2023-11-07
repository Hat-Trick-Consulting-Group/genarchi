#!/bin/bash

sudo cp -rf ./mongod.conf /etc/
sudo systemctl start mongod
sudo systemctl status mongod

# load configuration #TODO: update for later when implementing replication
# sudo mongosh --file setup_db.js

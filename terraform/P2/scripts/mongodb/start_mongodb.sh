#!/bin/bash

sudo systemctl start mongod
sudo systemctl status mongod

# load configuration #TODO: update for later when implementing replication
# sudo mongosh --file setup_db.js

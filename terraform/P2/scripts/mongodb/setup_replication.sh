#!/bin/bash

# File to be called in the primary node only

# Get the machine's IP address dynamically
MONGO_HOST_1=${machine_ip_1}
MONGO_HOST_2=${machine_ip_2}
MONGO_HOST_3=$(hostname -I | awk '{print $1}')

# MongoDB shell command to initiate the replica set
mongosh --eval "rs.initiate({
  _id: 'rs0',
  members: [
    { _id: 0, host: '$MONGO_HOST_1:${db_port}' },
    { _id: 1, host: '$MONGO_HOST_2:${db_port}' },
    { _id: 2, host: '$MONGO_HOST_3:${db_port}' }
  ]
})"

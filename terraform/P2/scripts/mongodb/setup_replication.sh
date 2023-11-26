#!/bin/bash

# File to be called in the primary node only

# Wait for mongod to start
sleep 10

# Get the machine's IP address dynamically
MONGO_HOST_1=${db_host_ip_1}
MONGO_HOST_2=${db_host_ip_2}
MONGO_HOST_3=$(hostname -I | awk '{print $1}')

# Print the MongoDB shell command for debugging
echo "Executing MongoDB shell command:"
echo "mongosh --eval \"rs.initiate({
  _id: 'rs0',
  members: [
    { _id: 0, host: '$MONGO_HOST_1:${db_port}' },
    { _id: 1, host: '$MONGO_HOST_2:${db_port}' },
    { _id: 2, host: '$MONGO_HOST_3:${db_port}' }
  ]
})\""

# MongoDB shell command to initiate the replica set
mongosh --eval "rs.initiate({
  _id: 'rs0',
  members: [
    { _id: 0, host: '$MONGO_HOST_1:${db_port}' },
    { _id: 1, host: '$MONGO_HOST_2:${db_port}' },
    { _id: 2, host: '$MONGO_HOST_3:${db_port}' }
  ]
})"
status=$?

# Check if the command was successful (status code 0)
if [ $status -eq 0 ]; then
    echo "MongoDB replication initiated successfully."
else
    echo "Error: MongoDB replication initiation failed with status $status."
fi

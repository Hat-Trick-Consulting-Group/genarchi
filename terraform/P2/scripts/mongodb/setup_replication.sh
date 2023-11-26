#!/bin/bash

# File to be called in the primary node only

# Check if required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <machine_ip_1> <machine_ip_2> <db_port>"
    exit 1
fi

# Wait for the MongoDB service to start
echo "Waiting for the MongoDB service to start..."
sleep 10

# Get machine IP addresses and MongoDB port from command-line arguments
MONGO_HOST_1=$1
MONGO_HOST_2=$2
DB_PORT=$3
MONGO_HOST_3=$(hostname -I | awk '{print $1}')

# Print the MongoDB shell command for debugging
echo "Executing MongoDB shell command:"
echo "mongosh --eval \"rs.initiate({
  _id: 'rs0',
  members: [
    { _id: 0, host: '$MONGO_HOST_1:$DB_PORT' },
    { _id: 1, host: '$MONGO_HOST_2:$DB_PORT' },
    { _id: 2, host: '$MONGO_HOST_3:$DB_PORT' }
  ]
})\""

# MongoDB shell command to initiate the replica set
mongosh --eval "rs.initiate({
  _id: 'rs0',
  members: [
    { _id: 0, host: '$MONGO_HOST_1:$DB_PORT' },
    { _id: 1, host: '$MONGO_HOST_2:$DB_PORT' },
    { _id: 2, host: '$MONGO_HOST_3:$DB_PORT' }
  ]
})"
status=$?

# Check if the command was successful (status code 0)
if [ $status -eq 0 ]; then
    echo "MongoDB replication initiated successfully."
else
    echo "Error: MongoDB replication initiation failed with status $status."
fi

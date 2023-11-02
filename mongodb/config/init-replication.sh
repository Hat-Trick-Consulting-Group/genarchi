#!/bin/bash

# Wait for the primary MongoDB container to be ready (you can use another tool for this, like wait-for-it.sh).
# For simplicity, we'll just sleep for a few seconds here.
sleep 10

# Initiate replication in the primary MongoDB container
docker exec -it primary-mongo mongo -u root -p example_password --eval "rs.initiate({
  _id: 'rs0',
  members: [
    { _id: 0, host: 'primary-mongo:27017' },
    { _id: 1, host: 'replica-mongo:27017' }
  ]
})"

# Sleep to keep the container running and ensure the replication is initialized
sleep infinity

#!/bin/bash

# Update the OS and install necessary packages
sudo apt-get update

# Clone only the mongodb folder from the repository
git clone --depth 1 --branch ${git_branch} --no-checkout https://github.com/Hat-Trick-Consulting-Group/genarchi.git
cd genarchi
git sparse-checkout set terraform/P2/scripts/mongodb
git checkout ${git_branch}
cd terraform/P2/scripts/mongodb

# Install MongoDB
source ./install_mongodb.sh

# Generate the MongoDB configuration file
source ./generate_mongod_conf.sh

# Start MongoDB
source ./start_mongodb.sh

# Setup MongoDB replication if this is the last node to be created
if [ ${is_last_node} == "true" ]; then
  source ./setup_replication.sh
fi

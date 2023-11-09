#!/bin/bash

# Update the OS and install necessary packages
sudo yum update -y
sudo yum install -y docker git

# Clone only the mongodb folder from the repository
git clone --depth 1 --branch ${git_branch} --no-checkout https://github.com/Hat-Trick-Consulting-Group/genarchi.git
cd genarchi
git sparse-checkout set terraform/P2/scripts/mongodb
git checkout ${git_branch}
cd terraform/P2/scripts/mongodb

# Install MongoDB
source ./install_mongodb.sh

# Start MongoDB
source ./start_mongodb.sh

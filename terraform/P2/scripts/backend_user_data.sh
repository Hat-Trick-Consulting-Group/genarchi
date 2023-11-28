#!/bin/bash

# Update the OS and install necessary packages
sudo yum update -y
sudo yum install -y docker git

# Install Go (adjust the version as needed)
sudo yum install -y golang
export GOPATH=/go
export GOCACHE=/go/cache
export PATH=$PATH:$GOPATH/bin

# Clone your Git repository
git clone https://github.com/Hat-Trick-Consulting-Group/genarchi.git

# Change directory to the cloned repository
cd genarchi
git checkout ${git_branch}

# Change directory to the backend and run your Go application
cd backend
# Set .env.production variables
echo "MONGO_URI=mongodb://${db_host_ip_1}:${db_port},${db_host_ip_2}:${db_port},${db_host_ip_3}:${db_port}/?replicaSet=rs0" >> .env.production

GO_ENV=production go run main.go

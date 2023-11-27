#!/bin/bash

# Update the OS and install necessary packages
sudo yum update -y
sudo yum install -y docker git

# Install Go (adjust the version as needed)
sudo yum install -y golang
export GOPATH=/go
export GOCACHE=/go/cache
export PATH=$PATH:$GOPATH/bin

# Install Node.js and npm
sudo yum install https://rpm.nodesource.com/pub_21.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1

# Clone your Git repository
git clone https://github.com/Hat-Trick-Consulting-Group/genarchi.git

# Change directory to the cloned repository
cd genarchi
git checkout ${git_branch}

# Change directory to the backend and run your Go application
cd backend
# Switch to the production environment to use .env.production
export GO_ENV=production
# Set .env.production variables
echo "MONGO_URI=mongodb://${db_host_ip_1}:${db_port},${db_host_ip_2}:${db_port},${db_host_ip_3}:${db_port}/?replicaSet=rs0" >> .env.production

go run main.go &

# Change directory to the frontend and run your React application
cd ../frontend
echo "VITE_API_URL=http://${alb_dns_name}:8080" >> .env.production
cat .env.production
npm install
npm run build

# Serve the production build on port 80 using 'serve'
sudo npm install -g serve
sudo serve -s dist -l 80 --no-port-switching --cors &

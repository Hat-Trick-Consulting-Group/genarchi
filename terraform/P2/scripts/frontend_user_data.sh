#!/bin/bash

# Update the OS and install necessary packages
sudo yum update -y
sudo yum install -y docker git

# Install Node.js and npm
sudo yum install https://rpm.nodesource.com/pub_21.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1

# Clone your Git repository
git clone https://github.com/Hat-Trick-Consulting-Group/genarchi.git

# Change directory to the cloned repository
cd genarchi
git checkout ${git_branch}

# Store ip address of current frontend instance
FRONTEND_IP=$(hostname -I | awk '{print $1}')

# Change directory to the frontend and run your React application
cd frontend/
echo "VITE_API_URL=http://${alb_dns_name}:8080" >> .env.production
echo "VITE_FRONTEND_IP=$FRONTEND_IP" >> .env.production
cat .env.production
npm install
npm run build

# Serve the production build on port 80 using 'serve'
sudo npm install -g serve
sudo serve -s dist -l 80 --no-port-switching --cors &

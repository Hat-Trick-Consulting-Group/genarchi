#!/bin/bash

# Update the OS and install necessary packages
sudo yum update -y
sudo yum install -y docker git

# Install Node.js and npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
. ~/.nvm/nvm.sh
nvm install --lts

# Clone your Git repository
git clone https://github.com/Hat-Trick-Consulting-Group/genarchi.git

sudo chown -R $(whoami) /genarchi/frontend

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
npm install -g serve
serve -s dist -l 80 --no-port-switching --cors &

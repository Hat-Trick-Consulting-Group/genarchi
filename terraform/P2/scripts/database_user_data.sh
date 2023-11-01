#!/bin/bash

# Update the OS and install necessary packages
sudo yum update -y
sudo yum install -y docker git

# Install Docker Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo service docker start
sudo systemctl enable docker

# Clone only the docker-compose.yml file from your Git repository
git clone --depth 1 --branch p2-v2-separate-db-from-app --no-checkout https://github.com/Hat-Trick-Consulting-Group/genarchi.git
cd genarchi
git sparse-checkout set docker-compose.yml
git checkout p2-v2-separate-db-from-app

# Set production environment variables
mkdir db_config
echo "PSQL_PORT=${db_port}" >> db_config/.env.production
echo "PSQL_USER=${db_username}" >> db_config/.env.production
echo "PSQL_PASSWORD=${db_password}" >> db_config/.env.production
echo "PSQL_DBNAME=${db_name}" >> db_config/.env.production

# Start your Docker Compose services (assuming you have a Docker Compose file)
sudo docker-compose --env-file ./db_config/.env.production up --build

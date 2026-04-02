#!/bin/bash

# 1. Update system packages
sudo apt update -y
sudo apt upgrade -y

# 2. Install Nginx
sudo apt install -y nginx
sudo ufw allow 'Nginx HTTP'
sudo systemctl enable nginx
sudo systemctl start nginx

# 3. Install Node.js and PM2
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2

# 4. Install MongoDB Community Edition
# Installing libssl1.1 dependency which is required for MongoDB
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb

# Import the public key used by the package management system
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

# Create the list file for MongoDB
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Reload local package database and install MongoDB
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable mongod
sudo systemctl start mongod

# 5. Run the Node.js application and install dependencies
# Change directory for the application
APP_DIR="/home/ubuntu/node_dummy_app"
sudo mkdir -p $APP_DIR
sudo chown -R ubuntu:ubuntu $APP_DIR

# Clone the app and install dependencies
cd $APP_DIR
sudo -u ubuntu git clone https://bitbucket.org/divyam-singal/node_dummy_app/ .
sudo -u ubuntu npm install

# Start the application using PM2
sudo -u ubuntu pm2 start server.js --name "node-app"
# 6. Set up a basic Nginx reverse proxy configuration
CONFIG="
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
"
echo "$CONFIG" | sudo tee /etc/nginx/sites-available/default

# Restart Nginx to apply the new configuration
sudo systemctl restart nginx

# 7. Verification step
# Wait for the app to start, then check the /test endpoint
sleep 10
# Note: Since the app is behind Nginx, we check port 80 (or just the local host)
APP_STATUS=$(curl -s http://localhost/test)
if curl -s http://localhost/test | grep -q "running"; then
    echo "Application verification successful. MongoDB connection verified."
    echo $APP_STATUS
else
    echo "Application verification failed."
fi
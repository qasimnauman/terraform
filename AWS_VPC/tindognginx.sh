#!/bin/bash

sudo apt update
sudo apt install nginx -y

cd /var/www
sudo git clone https://github.com/qasimnauman/tindog_website.git

cd /etc/nginx/sites-available/
sudo tee /etc/nginx/sites-available/tindog.conf > /dev/null <<EOF
server {
       listen 82;
       listen [::]:82;

       server_name example.ubuntu.com;

       root /var/www/tindog_website;
       index index.html;

       location / {
               try_files \$uri \$uri/ =404;
       }
}
EOF

sudo ln -s /etc/nginx/sites-available/tindog.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx.service
#!/bin/bash

sudo apt update
sudo apt install nginx -y

# sudo ufw allow 'Nginx Full'
# sudo ufw allow 'Nginx HTTP'
# sudo ufw allow 'Nginx HTTPS'
# sudo ufw allow 80
# sudo ufw allow 81
# sudo ufw enable -y

sudo mkdir -p /var/www/website

sudo tee /var/www/website/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>My Portfolio</title>
    <style>
    /* Add animation and styling for the text */
    @keyframes colorChange {
      0% { color: red; }
      50% { color: green; }
      100% { color: blue; }
    }
    h1 {
      animation: colorChange 2s infinite;
    }
  </style>
</head>
<body>
  <h1>Terraform Project Server 1</h1>
  <p>Congratulations on deploying your first site on nginx</p>
</body>
</html>
EOF

cd /etc/nginx/sites-available/
sudo tee /etc/nginx/sites-available/myweb.conf > /dev/null <<EOF
server {
       listen 81;
       listen [::]:81;

       server_name example.ubuntu.com;

       root /var/www/website;
       index index.html;

       location / {
               try_files \$uri \$uri/ =404;
       }
}
EOF

sudo ln -s /etc/nginx/sites-available/myweb.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx.service
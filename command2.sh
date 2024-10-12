#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker 
sudo usermod -a -G docker ec2-user
sudo systemctl enable docker
sudo docker run -d -p 80:80 --name nginx-container nginx
sudo docker exec nginx-container /bin/bash -c "sed -i 's/<h1>Welcome to nginx!<\/h1>/<h1>Hola - Nginx 2 YA SABES<\/h1>/g' /usr/share/nginx/html/index.html"
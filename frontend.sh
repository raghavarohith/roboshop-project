yum install nginx -y
echo "install nginx SUCCESS"

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
cd /usr/share/nginx/html
rm -rf *
unzip -o /tmp/frontend.zip
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
systemctl enable nginx
systemctl restart nginx
yum install nginx -y
if [ $? -eq 0 ]
then
echo -e "\e[32m nginx SUCCESS in color\e[0m"
else
echo Failure
fi

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
cd /usr/share/nginx/html
rm -rf *
unzip -o /tmp/frontend.zip
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
systemctl enable nginx
systemctl restart nginx
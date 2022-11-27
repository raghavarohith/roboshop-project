COMPONENT=frontend
source common.sh

PRINT "install nginx"
yum install nginx -y &>>{LOG}
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE

mv frontend-main/static/* . &>>{LOG}
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>{LOG}

PRINT "Update RoboShop Configuration"
sed -i -e '/catalogue/ s/localhost/dev-catalogue.mydevops410.online	/' /etc/nginx/default.d/roboshop.conf
STAT $?

PRINT "enable nginx"
systemctl enable nginx &>>{LOG}
STAT $?

PRINT "restart nginx"
systemctl restart nginx &>>{LOG}
STAT $?
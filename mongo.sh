
COMPONENT=mongodb
source common.sh

PRINT "MONGO REPO FILE"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
STAT $?

PRINT "install mongo db"
yum install -y mongodb-org &>>${LOG}
STAT $?

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

DOWNLOAD_APP_CODE

PRINT "mongo catalogue"
mongo < catalogue.js &>>${LOG}
STAT $?

PRINT "mongo user"
mongo < users.js &>>${LOG}
STAT $?

PRINT "enable mongodb"
systemctl enable mongod &>>${LOG}
STAT $?

PRINT "restart mongodb"
systemctl restart mongod &>>${LOG}
STAT $?
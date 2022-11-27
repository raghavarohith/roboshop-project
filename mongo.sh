COMPONENT=mongodb
source common.sh

PRINT "download repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>{LOG}
STAT $?

PRINT "install mongodb"
yum install -y mongodb-org &>>{LOG}
STAT $?


PRINT "update listen ip"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongod.conf &>>{LOG}
STAT $?

PRINT "enable monodb"
 systemctl enable mongod &>>{LOG}
 STAT $?
PRINT "start mongodb"
systemctl restart mongod &>>{LOG}
STAT $?

APP_LOC=/tmp
CONTENT=mongodb-main
DOWNLOAD_APP_CODE

cd mongodb-main &>>{LOG}
 mongo < catalogue.js &>>{LOG}
mongo < users.js &>>{LOG}

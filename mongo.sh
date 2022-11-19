curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
yum install -y mongodb-org
if [ $? -eq 0 ]; then
echo -e "\e[34m SUCCESS INSTALLED\e[0m"
else
echo FAILURE
fi
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

cd /tmp
unzip -o mongodb.zip
cd mongodb-main
mongo < catalogue.js
mongo < users.js

systemctl enable mongod
systemctl restart mongod
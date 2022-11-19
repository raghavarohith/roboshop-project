curl -sL https://rpm.nodesource.com/setup_lts.x | bash
if [ $? -eq 0 ]; then
  echo SUCCESS
  fi
yum install nodejs -y
if [ $? -eq 0 ]
then
echo SUCCESS
fi
useradd roboshop
if [ $? -eq 0 ]; then
echo SUCCESS
fi
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
if [ $? -eq 0 ]; then
echo SUCCESS
fi
cd /home/roboshop
if [ $? -eq 0 ]; then
echo SUCCESS
fi
unzip -o /tmp/catalogue.zip
mv catalogue-main catalogue
cd /home/roboshop/catalogue
npm install

sed -e -i 's/MONGO_DNSNAME/mongodb.devopslearning69.online' /home/roboshop/catalogue/systemd.service

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload

systemctl enable catalogue
systemctl restart catalogue
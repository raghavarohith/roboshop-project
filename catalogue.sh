curl -sL https://rpm.nodesource.com/setup_lts.x | bash
if [ $? -eq 0 ]; then
  echo SUCCESS
  fi
yum install nodejs -y
if [ $? -eq 0 ]
then
echo SUCCESS
fi
if  [ $? -ne 0 ]
then
useradd roboshop
fi

curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
cd /home/roboshop
if [ $? -eq 0 ]; then
echo SUCCESS
fi
unzip -o /tmp/catalogue.zip
if [ $? -ne 0 ]
then
mv catalogue-main catalogue
fi
cd /home/roboshop/catalogue
npm install

if [ $? -ne 0 ]
then
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
fi
sed -e -i 's/MONGODNSNAME/mongodb.devopsb69.online/' /etc/systemd/system/catalogue.service

systemctl daemon-reload

systemctl enable catalogue
systemctl restart catalogue
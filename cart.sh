source common.sh
PRINT "INSTALL NODEJS REPOS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
STAT $?

PRINT "install nodejs"
yum install nodejs -y
STAT $?

PRINT "Adding application user"
useradd roboshop
STAT $?

PRINT "download app content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
STAT $?

PRINT "remove previous "
cd /home/roboshop
rm -rf cart
STAT $?

PRINT "extracting app content"
unzip -o /tmp/cart.zip
STAT $?

mv cart-main cart
cd cart

PRINT "install dependencies"
npm install
STAT $?

PRINT "configuration endpoints"
sed -i -e 's/REDIS_ENDPOINT/redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devopsb69.online/' systemd.service
STAT $?
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
PRINT "system reload"
systemctl daemon-reload
STAT $?

PRINT "enable"
systemctl enable cart
STAT $?

PRINT "restart"
systemctl restart cart
STAT $?
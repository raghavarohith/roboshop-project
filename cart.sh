source common.sh
curl -sL https://rpm.nodesource.com/setup_lts.x | bash >/tmp/test
STAT
if [ $? -ne 0 ]; then
useradd roboshop
fi
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" >/tmp/test
cd /home/roboshop
rm -rf cart
unzip -o /tmp/cart.zip >/tmp/test
mv cart-main cart
cd cart
npm install >/tmp/test
if [ $? -eq 0 ]; then
echo -e "\e[33m SUCCESS NPM INSTALLED\e[0m"
fi
sed -i -e 's/REDIS_ENDPOINT/redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devopsb69.online/' systemd.service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service >/tmp/test
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
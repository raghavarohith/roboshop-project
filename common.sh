STAT () {
if [ $? -eq 0 ]
then
echo -e "\e[1;32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  echo check the erroor in $LOG file
  exit
fi
}
PRINT (){
  echo "-------------$1--------" >>${LOG}
  echo -e "\e[33m$1\e[0m"
  }

LOG=/tmp/$COMPONENT.log
rm -f $LOG


NODEJS () {

  PRINT "INSTALL NODEJS REPOS"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
  STAT $?

  PRINT "install nodejs"
  yum install nodejs -y &>>$LOG
  STAT $?

  PRINT "Adding application user"
  id roboshop &>>$LOG
  if [ $? -ne 0 ]; then
  useradd roboshop &>>$LOG
  fi
  STAT $?

  PRINT "download app content"
  curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>$LOG
  STAT $?

  PRINT "remove previous "
  cd /home/roboshop &>>$LOG
  rm -rf cart &>>$LOG
  STAT $?

  PRINT "extracting app content"
  unzip -o /tmp/cart.zip &>>$LOG
  STAT $?

  mv cart-main cart
  cd cart

  PRINT "install dependencies"
  npm install &>>$LOG
  STAT $?

  PRINT "configuration endpoints"
  sed -i -e 's/REDIS_ENDPOINT/redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devopsb69.online/' systemd.service &>>$LOG
  STAT $?
  mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
  PRINT "system reload"
  systemctl daemon-reload &>>$LOG
  STAT $?

  PRINT "enable"
  systemctl enable cart &>>$LOG
  STAT $?

  PRINT "restart"
  systemctl restart cart &>>$LOG
  STAT $?

}

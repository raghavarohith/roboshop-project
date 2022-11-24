STAT() {
if [ $? -eq 0 ]
then
echo -e "\e[1;32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  echo check the erroor in $LOG file
  exit
fi
}
PRINT() {
  echo "-------------$1--------" >>${LOG}
  echo -e "\e[33m$1\e[0m"
  }

LOG=/tmp/$COMPONENT.log
rm -f $LOG

DOWNLOAD_APP_CODE() {
  if [ ! z "$APP_USER" ]; then
      PRINT "Adding application user"
      id roboshop &>>$LOG
      if [ $? -ne 0 ]; then
      useradd roboshop &>>$LOG
      fi
      STAT $?
      fi
PRINT "download app content"
 curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
  STAT $?

    PRINT "remove previous "
    cd $APP_LOC &>>$LOG
    rm -rf ${CONTENT} &>>$LOG
    STAT $?

    PRINT "extracting app content"
    unzip -o /tmp/${COMPONENT}.zip &>>$LOG
    STAT $?

}
SYSTEMD_SETUP() {
  sed -i -e 's/REDIS_ENDPOINT/redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devopsb69.online/' systemd.service &>>$LOG
    STAT $?
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service

  PRINT "reload daemon"
  systemctl daemon-reload
  STAT $?

  PRINT "start"
  systemctl start ${COMPONENT}
  STAT $?
  PRINT "eanble"
  systemctl enable ${COMPONENT}
  STAT $?
}

NODEJS() {
APP_LOC=/home/roboshop
CONTENT=$COMPONENT
APP_USER=roboshop
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

  DOWNLOAD_APP_CODE

  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}

  PRINT "install dependencies"
  npm install &>>$LOG
  STAT $?

  PRINT "configuration endpoints"
  sed -i -e 's/REDIS_ENDPOINT/redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devopsb69.online/' systemd.service &>>$LOG
  STAT $?
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  PRINT "system reload"
  systemctl daemon-reload &>>$LOG
  STAT $?

  PRINT "enable"
  systemctl enable ${COMPONENT} &>>$LOG
  STAT $?

  PRINT "restart"
  systemctl restart ${COMPONENT} &>>$LOG
  STAT $?

}

JAVA() {
APP_LOC=/home/roboshop
CONTENT=$COMPONENT
APP_USER=roboshop
PRINT "install maven"
yum install maven -y &>>$LOG
STAT $?

DOWNLOAD_APP_CODE
PRINT "maven dependencies"
  mvn clean package &>>$LOG && mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>$LOG
  STAT $?
SYSTEMD_SETUP
}
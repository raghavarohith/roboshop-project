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
  if [ ! -z "$APP_USER" ]; then
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
  PRINT "endpoint"
sed -i -e 's/REDIS_ENDPOINT/dev-redis.mydevops410.online/' -e 's/CATALOGUE_ENDPOINT/dev-catalogue.mydevops410.online/' -e 's/MONGO_ENDPOINT/dev-mongo.mydevops410.online/' -e 's/CARTENDPOINT/dev-cart.mydevops410.online/' -e 's/DBHOST/dev-mysql.mydevops410.online/' systemd.service &>>$LOG
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
STAT $?

  PRINT "reload daemon"
  systemctl daemon-reload
  STAT $?

  PRINT "start"
  systemctl restart ${COMPONENT}
  STAT $?
  PRINT "enable"
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

  DOWNLOAD_APP_CODE

  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}

  PRINT "install dependencies"
  npm install &>>$LOG
  STAT $?

 SYSTEMD_SETUP


}

JAVA() {
APP_LOC=/home/roboshop
CONTENT=$COMPONENT
APP_USER=roboshop

PRINT "install maven"
yum install maven -y &>>$LOG
STAT $?

DOWNLOAD_APP_CODE
mv ${COMPONENT}-main ${COMPONENT}
cd ${COMPONENT}

PRINT "maven dependencies"
mvn clean package &>>$LOG && mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>$LOG
STAT $?

SYSTEMD_SETUP
}

PYTHON() {

APP_LOC=/home/roboshop
CONTENT=$COMPONENT
APP_USER=roboshop

PRINT "python installation"
yum install python36 gcc python3-devel -y &>>{LOG}
STAT $?

DOWNLOAD_APP_CODE

PRINT "movement"

mv ${COMPONENT}-main ${COMPONENT}
STAT $?

PRINT "go to payment"
cd ${COMPONENT}
STAT $?


PRINT "pip installation"
pip3 install -r requirements.txt &>>{LOG}
STAT $?


USER_ID=$(id -u roboshop)
GROUP_ID=$(id -g roboshop)
sed -i -e "/uid/ c uid = ${USER_ID}" -e "/uid/ c uid = ${GROUP_ID}" /${COMPONENT}.ini

SYSTEMD_SETUP
}

GO_LANG() {

APP_LOC=/home/roboshop
CONTENT=$COMPONENT
APP_USER=roboshop

PRINT "install golang"
yum install golang -y &>>${LOG}
STAT $?

DOWNLOAD_APP_CODE

mv ${COMPONENT}-main ${COMPONENT} &>>${LOG}
cd ${COMPONENT} &>>${LOG}

PRINT "GO init"
go mod init dispatch &>>${LOG}
STAT $?

PRINT "GO GET"
go get &>>${LOG}
STAT $?

PRINT "GO BUILD"
go build &>>${LOG}
STAT $?


SYSTEMD_SETUP
}
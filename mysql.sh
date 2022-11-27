
if [ -z "$1" ]; then
  echo INPUT PASSWORD IS
  exit 1
  fi

COMPONENT=mysql
source common.sh
ROBOSHOP_MYSQL_PASSWORD=$1 &>>{LOG}

PRINT "DOWNLOADING MYSQL REPO FILE"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>{LOG}
STAT $?

PRINT "DISABLE MYSQL SERVICE"
dnf module disable mysql -y &>>{LOG}
STAT $?

 PRINT "INSTALL MYSQL SERVICE"
yum install mysql-community-server -y &>>{LOG}
STAT $?

 PRINT "MYSQL SERVICE ENABLE"
systemctl enable mysqld &>>{LOG}
STAT $?


 PRINT "MYSQL SERVICE START"
systemctl start mysqld &>>{LOG}
STAT $?

echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>{LOG}

if [ $? -ne 0 ]; then
echo "ALTER USER 'root'@'localhost' IDENTIFIED by '${ROBOSHOP_MYSQL_PASSWORD}';" >/tmp/root-pass-sql
DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD}
fi

PRINT "unisntall plugins validatre password"
 echo "show plugins" | mysql -uroot --p$ROBOSHOP_MYSQL_PASSWORD | grep validate_password &>>{LOG}
 if [ $? -eq 0 ]; then
   echo "uninstall plugin validate_password;" | mysql -uroot -p$ROBOSHOP_MYSQL_PASSWORD &>>{LOG}
fi
STAT $?

APP_LOC=/tmp

CONTENT=mysql-main

DOWNLOAD_APP_CODE

cd mysql-main &>>{LOG}
PRINT "load shipping schema"
mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} < shipping.sql &>>{LOG}
STAT $?




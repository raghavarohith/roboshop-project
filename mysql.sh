if [ -z "$1" ]; then
  echo INPUT PASSWORD IS NEEDED
  exit
  fi

ROBOSHOP_MYSQL_PASSWORD=$1 &>>/tmp/log
STAT () {
  if [ $1 -eq 0 ]
  then
    echo "SUCCESS"
  else
   echo "FAILURE""
   fi
}
PRINT (){
  echo -e "\e[34m$1\e[0m"
}
PRINT "DOWNLOADING MYSQL REPO FILE"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>/tmp/log
STAT $?
 PRINT "DISABLE MYSQL SERVICE"
dnf module disable mysql &>>/tmp/log
STAT $?
 PRINT "INSTALL MYSQL SERVICE"
yum install mysql-community-server -y &>>/tmp/log
STAT $?
 PRINT "MYSQL SERVICE ENABLE"
systemctl enable mysqld &>>/tmp/log
STAT $?

 PRINT "MYSQL SERVICE START"
systemctl start mysqld &>>/tmp/log
STAT $?

echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>/tmp/log

if [ $? -ne 0 ]; then
echo "ALTER USER 'root'@'localhost' IDENTIFIED by '${ROBOSHOP_MYSQL_PASSWORD}';" >/tmp/root-pass-sql
DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"
fi
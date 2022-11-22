if [ -z "$1" ]; then
  echo INPUT PASSWORD IS NEEDED
  exit
  fi

ROBOSHOP_MYSQL_PASSWORD=$1
STAT () {
  if [ $1 -eq 0 ]
  then
    echo SUCCESS
  else
   echo FAILURE
   fi
}
PRINT (){
  echo -e "\e[34m$1\e[0m"
}

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
STAT $?
 PRINT "DISABLE MYSQL SERVICE"
dnf module disable mysql
STAT $?
 PRINT "INSTALL MYSQL SERVICE"
yum install mysql-community-server -y
STAT $?
 PRINT "MYSQL SERVICE ENABLE"
systemctl enable mysqld
STAT $?

 PRINT "MYSQL SERVICE START"
systemctl start mysqld
STAT $?

echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}

if [ $? -ne 0 ]; then
echo "ALTER USER 'root'@'localhost' IDENTIFIED by '${ROBOSHOP_MYSQL_PASSWORD}@1';" >/tmp/root-pass-sql
DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
cat /tmp/root-pass-sql | mysql --connect-expired-password  -uroot -p"${DEFAULT_PASSWORD}"
fi
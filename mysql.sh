if [ -n "$1" ]; then
  echo INPUT PASSWORD IS NEEDED
  exit
  fi

ROBOSHOP_MYSQL_PASSWORD=$1
echo -e "\e[34mDOWNLOADING MYSQL REPO FILE\e[0m"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
if [ $? -eq 0 ]
then
  echo SUCCESS
else
 echo FAILURE
 fi
 echo DISABLE MYSQL SERVICE
dnf module disable mysql
if [ $? -eq 0 ]
then
  echo SUCCESS
else
 echo FAILURE
 fi
 echo INSTALL MYSQL SERVICE
yum install mysql-community-server -y
if [ $? -eq 0 ]
then
  echo SUCCESS
else
 echo FAILURE

 fi
 echo MYSQL SERVICE ENABLE
systemctl enable mysqld
if [ $? -eq 0 ]
then
  echo SUCCESS
else
 echo FAILURE
 fi
 echo MYSQL SERVICE START
systemctl start mysqld
if [ $? -eq 0 ]
then
  echo SUCCESS
else
 echo FAILURE
 fi

echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}

if [ $? -ne 0 ]; then
echo "ALTER USER 'root'@'localhost' IDENTIFIED by '${ROBOSHOP_MYSQL_PASSWORD}@1';" >/tmp/root-pass-sql
DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
cat /tmp/root-pass-sql | mysql --connect-expired-password  -uroot -p"${DEFAULT_PASSWORD}"
fi
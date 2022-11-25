COMPONENT=redis
source common.sh

PRINT "redis repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>{LOG}
STAT $?

PRINT "module enable"
dnf module enable redis:remi-6.2 -y &>>{LOG}
STAT $?

PRINT "install redis"
yum install redis -y &>>{LOG}
STAT $?

PRINT "listen ip"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>{LOG}
STAT $?

PRINT "enable redis"
systemctl enable redis &>>{LOG}
STAT $?

PRINT "restart redis"
systemctl restart redis &>>{LOG}
STAT $?
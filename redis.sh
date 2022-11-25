dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>{LOG}
dnf module enable redis:remi-6.2 -y &>>{LOG}
yum install redis -y &>>{LOG}

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>{LOG}

systemctl enable redis &>>{LOG}
systemctl restart redis &>>{LOG}
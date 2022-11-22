STAT () {
yum install nodejs -y >/tmp/log/txt
if [ $? -eq 0 ]
then
echo SUCCESS
fi
}
STAT
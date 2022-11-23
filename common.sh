STAT () {
yum install nodejs -y >/tmp/log
if [ $? -eq 0 ]
then
echo SUCCESS
fi
}
STAT
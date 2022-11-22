STAT () {
yum install nodejs -y
if [ $? -eq 0 ]
then
echo SUCCESS
fi
}
STAT
STAT () {
if [ $? -eq 0 ]
then
echo -e "\e[1;32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  echo check the erroor in $LOG file
  exit
fi
}
PRINT (){
  echo "-------------$1--------" >>${LOG}
  echo -e "\e[33m$1\e[0m"
  }

LOG=/tmp/$COMPONENT.log
rm -f $LOG

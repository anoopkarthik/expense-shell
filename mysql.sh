#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

#echo "User ID is: $USERID"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "$R Please run this script with root priveleges $N" | tee -a $LOG_FILE
        exit 1
    fi

}

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is ..$R FAILED $N" | tee -a &>>$LOG_FILE
        exit 1
    else 
        echo -e "$2 is .. $G SUCCESS $N"  | tee -a &>>$LOG_FILE
        fi
}

echo "script started executing at:: $(date)"  | tee -a $LOG_FILE


CHECK_ROOT


dnf install mysql-server -y
VALIDATE $? "Installing mysql server"

systemctl enable mysqld
VALIDATE $? "Enabled mysqld server"

systemctl start mysqld
VALIDATE $? "Started mysqld server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "Setting up mysl server"
  
#!/bin/bash

hostname=$(hostname)
newdb='wordpress' #Имя базы данных 
userdb='sadmindb' #Имя пользователя базы данных
userpass='Aa123456' #Пароль от базы данных
#for file backupdb.sh:
PROJNAME=WPLAMPBACKUP #Имя проекта
CHARSET=utf8 #Кодировка базы данных (utf8)
DBNAME=$newdb #Имя базы данных для резервного копирования
DBFILENAME="backup_$hostname" #Имя дампа базы данных
ARFILENAME=backupdb #Имя архива с файлами
HOST=localhost #Хост MySQL
USER=$userdb #Имя пользователя базы данных
PASSWD=$userpass #Пароль от базы данных
DATADIR=~/backup #Путь к каталогу где будут храниться резервные копии
SRCFILES=/var/www/$hostname #Путь к каталогу файлов для архивирования
PREFIX=`date +%F` #Префикс по дате для структурирования резервных копий

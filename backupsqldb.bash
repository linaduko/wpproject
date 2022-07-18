#!/bin/bash

#Создание директорий для хранения бэкапов
mkdir $HOME/backup

dirforbackups=$(echo "$HOME/backup")
datename=$(date +%F--%H-%M)

#Создание бэкапа базы данных wordpress и перенаправление вывода в хранилище
sudo mysqldump -u$userdb -p$userpass $newdb > $dirforbackups/$datename.sql


#!/bin/bash
#Установка Cron - демона для выполнения задач по расписанию
sudo apt install cron
sudo systemctl enable cron

#Копирование бэкап-скрипта в директорию /etc/cron.daily для ежедневного выполнения
sudo cp ./backupsqldb.bash /etc/cron.daily

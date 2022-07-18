#!/bin/bash

#Установка флага исполнения на файлы скриптов
chmod +x wplamp.bash backupsqldb.bash crondaily.sh

#Создание отношений между файлами скриптов
. ./wplamp.bash && . ./backupsqldb.bash && . ./crondaily.bash

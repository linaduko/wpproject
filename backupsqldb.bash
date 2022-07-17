#!/bin/bash

#actualdir=$(pwd)
#. $actualdir/wplamp.bash

echo $userdb $userpass $newdb
mkdir $HOME/backup
#sudo chown -R $USER:$USER $HOME/backup
#sudo chmod -R 664 $HOME/backup
dirforbackups=$(echo "$HOME/backup")
datename=$(date +%F--%H-%M)
#mysqldump -usadmindb -pAa123456 wordpress > $dirforbackups/$datename-new.sql
sudo mysqldump -u$userdb -p$userpass $newdb > $dirforbackups/$datename.sql


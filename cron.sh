#!/bin/bash

sudo apt install cron
sudo systemctl enable cron
actualdir=$(pwd)
sed -i "4iactualdir=$(pwd)" backupdb.sh
sudo cp backupdb.sh /etc/cron.daily


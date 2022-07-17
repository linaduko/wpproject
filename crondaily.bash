#!/bin/bash
sudo apt install cron
sudo systemctl enable cron

sudo cp ./backupsqldb.bash /etc/cron.daily

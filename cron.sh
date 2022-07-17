#!/bin/bash

sudo apt install cron
sudo systemctl enable cron
sudo cp backupdb.sh /etc/cron.daily

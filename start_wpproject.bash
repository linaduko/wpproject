#!/bin/bash
chmod +x wplamp.bash backupsqldb.bash crondaily.sh

. ./wplamp.bash && . ./backupsqldb.bash && . ./crondaily.bash
echo OK 

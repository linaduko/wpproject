#!/bin/bash
#daem prava na vipolnenie
chmod +x wplamp.bash cron.sh backupdb.sh
#vperda
. ./wplamp.bash && . ./cron.sh
echo The cake is a lie.


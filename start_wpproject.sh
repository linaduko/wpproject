#!/bin/bash
#daem prava na vipolnenie
chmod +x wplamp.bash
chmod +x cron.sh
chmod +x backupdb.sh
#vperda
. ./wplamp.bash && . ./cron.sh
echo The cake is a lie.

#!/bin/bash
#4ernovik (vozmozhno polnaya fignya)
#daem prava na vipolnenie
chmod +x wplamp.bash
chmod +x backupdb.sh
#vperda
. ./wplamp.bash && . ./backupdb.sh
echo The cake is a lie.

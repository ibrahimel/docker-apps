#!/bin/bash

echo $(whoami)
#echo 'Entering temp'
#cd /tmp

echo 'Running portainer'
sh -c "/portainer" &

#echo 'Creating app'
#nativefier -i /usr/share/icons/portainer.png --name="portainer" "http://localhost:9000"

echo 'Running app'
./opt/portainer*/portainer

#!/bin/bash

echo 'Running portainer'
sh -c "/portainer" &

echo 'Running app'
./opt/portainer*/portainer

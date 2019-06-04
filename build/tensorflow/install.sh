#!/bin/bash

echo 'Entering opt'
cd /opt

echo 'Running notebook'
sh -c "jupyter notebook --allow-root --notebook-dir=/tf --ip=127.0.0.1 --no-browser 2>/tmp/jupyter.log" &

sleep 3

#cat /tmp/jupyter.log

#echo 'Getting token'
#cat /tmp/jupyter.log | grep http:// | head -n 1 > /tmp/token
#sed -i 's/^.*\] //' /tmp/token

#echo "Link : $(cat /tmp/token)"
echo 'Creating app'
cd /opt
nativefier -i /usr/share/icons/tensorflow.png --name="Jupyter Notebook" "http://127.0.0.1:8888"


#!/bin/bash

echo 'Entering opt'
cd /opt

echo 'Running notebook'
sh -c "jupyter notebook --allow-root --notebook-dir=/tf --ip=127.0.0.1 --no-browser 2>/tmp/jupyter.log" &

sleep 3

echo 'Creating app'
cd /opt
nativefier -i /usr/share/icons/tensorflow.png --name="Jupyter Notebook" "http://127.0.0.1:8888"

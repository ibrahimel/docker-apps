#!/bin/bash

source /etc/bash.bashrc

# Copy Templates
cp -r /tf $HOME/

# Check for jupyter folder
if [ ! -d ~/.jupyter ]; then
	mkdir ~/.jupyter
fi

# Run Jupyter
echo 'Running notebook'
nohup jupyter notebook --notebook-dir=$HOME/tf --ip=127.0.0.1 --no-browser > ~/.jupyter/jupyter.log 2>&1 &

# Wait for jupyter to start
sleep 3

# Get token if first launch before using password
echo 'Getting token'

cat ~/.jupyter/jupyter.log | grep http:// | head -n 1 > ~/.jupyter/token
sed -i 's/^.*\] //' ~/.jupyter/token

TOKEN=$(cat ~/.jupyter/token | grep token)

# If token generated send it to user
if [ -n "$TOKEN" ]; then
	sed -i 's@http://127.0.0.1:8888/?token=@@' ~/.jupyter/token
	gxmessage "Please use this token to set a password: $(cat ~/.jupyter/token)"
fi

# Run App 
echo 'Running App'
/opt/jupyter-notebook-linux-x64/jupyter-notebook
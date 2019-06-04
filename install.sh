#!/bin/bash

# Install .docker-apps directory
echo '[Docker-apps] -- Checking and creating necessary folders'

if [ ! -d ~/.docker-apps ]; then
	mkdir ~/.docker-apps
fi

# Copy build files
echo '[Docker-apps] -- Copying bin and build files'
cp -r ./build ~/.docker-apps/
cp -r ./bin ~/.docker-apps/
cp -r ./*.sh ~/.docker-apps/

if [ ! -d ~/.docker-apps/homes ]; then
	mkdir ~/.docker-apps/homes
fi

# Check files are in PATH
IN_PATH=$(echo $PATH | grep "~/.docker-apps/bin:")

if [ ! -n "$IN_PATH" ]; then
	echo 'export PATH="~/.docker-apps/bin:$PATH"' >> ~/.bashrc
fi

source "$(pwd)/spinner.sh"
cd build/

# Install and build docker images
if [ $# -eq 0 ]; then
	list=$(ls)
	for package in $list; do
		if [ -d $package ]; then
			start_spinner "[Docker-apps] -- Installing package: $package"
			sh -c "cd ./$package && ./build.sh" > build.log 2>&1
			stop_spinner $?
		fi
	done
else
	for package in $@; do # In case specific apps were given
		if [ -d $package ]; then
			start_spinner "[Docker-apps] -- Installing package: $package"
			sh -c "cd ./$package && ./build.sh" > build.log 2>&1
			stop_spinner $?
		else
			echo "Package $package is not available !"
		fi
	done
fi

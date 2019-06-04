#!/bin/bash

echo '[Docker-apps] -- Preparing to update images'

source "$(pwd)/spinner.sh"
cd build/

# Update and build docker images
if [ $# -eq 0 ]; then
	list=$(ls)
	for package in $list; do
		if [ -d $package ]; then
			if [ -n "$(docker images $package:latest | grep $package)" ]; then
				start_spinner "[Docker-apps] -- Updating package: $package"
				sh -c "cd ./$package && docker build -t $package --pull ."  > build.log 2>&1
				stop_spinner $?
			fi
		fi
	done
else
	for package in $@; do # In case specific apps were given
		if [ -d $package ]; then
			if [ -n "$(docker images $package:latest | grep $package)" ]; then
				start_spinner "[Docker-apps] -- Updating package: $package"
				sh -c "cd ./$package && docker build -t $package --pull ."  > build.log 2>&1
				stop_spinner $?
			fi
		else
			echo "Package $package is not available !"
		fi
	done
fi

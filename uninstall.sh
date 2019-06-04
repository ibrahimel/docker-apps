#!/bin/bash

source "$(pwd)/spinner.sh"
cd build/

# Remove docker images and files
if [ $# -eq 0 ]; then
	# Check files are in PATH and remove them
	IN_PATH=$(echo $PATH | grep "~/.docker-apps/bin:")

	if [ -n "$IN_PATH" ]; then
		sed -i 's@$PATH="~/.docker-apps/bin:$PATH"@@' ~/.bashrc
	fi

	# Remove packages
	list=$(ls)
	for package in $list; do
		if [ -d $package ]; then
			if [ -n "$(docker images $package:latest | grep $package)" ]; then
				start_spinner "[Docker-apps] -- Removing package: $package"
				sh -c "docker rmi -f $package && rm ~/.local/share/applications/$package.desktop" > build.log 2>&1
				stop_spinner $?
			fi
		fi
	done

	# Prompt user for containes homes deletion
	read -p "Do you want to keep home folders (they will contain all persistant data) ? [y/n]" yn

	case $yn in
		[Nn]* ) echo '[Docker-apps] -- Deleting folders';rm -rf ~/.docker-apps;;
		[Yy]* ) echo '[Docker-apps] -- Keeping folders';;
		* ) echo "Please answer yes or no.";;
	esac
else
	for package in $@; do # In case specific apps were given
		if [ -d $package ]; then
			if [ -n "$(docker images $package:latest | grep $package)" ]; then
				start_spinner "[Docker-apps] -- Removing package: $package"
				sh -c "docker rmi -f $package && rm ~/.local/share/applications/$package.desktop" > build.log 2>&1
				stop_spinner $?
			fi
		else
			echo "Package $package is not available !"
		fi
	done
fi

# Done
echo '[Docker-apps] -- Uninstall done.'

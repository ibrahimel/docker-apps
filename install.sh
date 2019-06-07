#!/bin/bash

# Arguments
VPN=""
NVIDIA=""
ALL=""

# Parse arguments ... the lazy and stupid way
if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ] || [ "$3" = "--vpn" ]; then
	if [ -n "$(cat build/vpn-router/entrypoint.sh | grep fakeuser)" ]; then
		echo 'Your VPN configuration does not seem set. Please edit build/vpn-router/entrypoint.sh'
		exit
	fi
	VPN=" --vpn"
fi
if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ] || [ "$3" = "--vpn" ]; then
	if [ ! -x "/usr/bin/nvidia-docker" ]; then
		echo "Nvidia Docker runtime does not seem to be installed at /usr/bin !. Please install it using prereq script in ubuntu or refer to Nvidia docker in github"
		exit
	fi
	NVIDIA=" --nvidia"
fi
if [ "$1" = "--all" ] || [ "$2" = "--all" ] || [ "$3" = "--all" ]; then
	ALL=" --all"
fi
if [ "$1" = "--vpn" ] || [ "$1" = "--nvidia" ] || [ "$1" = "--all" ]; then
	shift
fi
if [ "$1" = "--vpn" ] || [ "$1" = "--nvidia" ] || [ "$1" = "--all" ]; then
	shift
fi
if [ "$1" = "--vpn" ] || [ "$1" = "--nvidia" ] || [ "$1" = "--all" ]; then
	shift
fi

# Install .docker-apps directory
echo '[Docker-apps] -- Checking and creating necessary folders'

if [ ! -d ~/.docker-apps ]; then
	mkdir ~/.docker-apps

	# Copy build files
	echo '[Docker-apps] -- Copying bin and build files'
	cp -r ./build ~/.docker-apps/
	cp -r ./bin ~/.docker-apps/
fi

# Check homes directory
if [ ! -d ~/.docker-apps/homes ]; then
	mkdir ~/.docker-apps/homes
fi

# Check homes directory
if [ ! -d ~/.local/share/applications ]; then
	mkdir ~/.local/share/applications
fi

# Check shared folder directory
if [ ! -d ~/Downloads/docker-apps ]; then
	mkdir ~/Downloads/docker-apps
fi

# Check bin files are in PATH
IN_PATH=$(echo $PATH | grep "~/.docker-apps/bin:")

if [ ! -n "$IN_PATH" ]; then
	echo 'export PATH="~/.docker-apps/bin:$PATH"' >> ~/.bashrc
fi

# Get ignore
ignored="$(cat .buildignore)"

source "$(pwd)/spinner.sh"
cd build/

# Install and build docker images
if [ -n "$ALL" ]; then
	list=$(ls)
	for package in $list; do
		if [ ! -n "$(echo $ignored | grep -w $package)" ]; then
			if [ -d $package ]; then
				start_spinner "[Docker-apps] -- Installing package: $package"
				sh -c "cd ./$package && ./build.sh$VPN$NVIDIA" > build.log 2>&1
				stop_spinner "$?"
			fi
		else
			echo "Skipping ignored package: $package"
		fi
	done
else
	for package in $@; do # In case specific apps were given
		if [ -d $package ]; then
			start_spinner "[Docker-apps] -- Installing package: $package"
			sh -c "cd ./$package && ./build.sh$VPN$NVIDIA" > build.log 2>&1
			stop_spinner "$?"
		else
			echo "Package $package is not available !"
		fi
	done
fi

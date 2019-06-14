#!/bin/bash

# Arguments
ALL=""
NVIDIA=""
NVARG=""
VPN=""

# Parse arguments ... the lazy and stupid way
if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ] || [ "$3" = "--vpn" ]; then
	if [ -n "$(cat build/vpn-router/entrypoint.sh | grep fakeuser)" ]; then
		echo 'Your VPN configuration does not seem set. Please edit build/vpn-router/entrypoint.sh'
		exit
	fi
	VPN=" --vpn"
else
	if [ "$1" = "--tor" ] || [ "$2" = "--tor" ] || [ "$3" = "--tor" ]; then
		VPN=" --tor"
	fi
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
if [ "$1" = "--vpn" ] || [ "$1" = "--nvidia" ] || [ "$1" = "--all" ] || [ "$1" = "--tor" ]; then
	shift
fi
if [ "$1" = "--vpn" ] || [ "$1" = "--nvidia" ] || [ "$1" = "--all" ] || [ "$1" = "--tor" ]; then
	shift
fi
if [ "$1" = "--vpn" ] || [ "$1" = "--nvidia" ] || [ "$1" = "--all" ] || [ "$1" = "--tor" ]; then
	shift
fi

echo '[Docker-apps] -- Preparing to update images'

source "$(pwd)/spinner.sh"
cd build/

# Update and build docker images
if [ -n "$ALL" ]; then
	list=$(ls)
	for package in $list; do
		if [ -d $package ]; then
			if [ -n "$(docker images $package:latest | grep $package)" ]; then
				start_spinner "[Docker-apps] -- Updating package: $package"
				sh -c "cd ./$package && docker build -t $package --pull --no-cache $NVIDIA. && ./build.sh $NVARG $VPN"  > build.log 2>&1
				stop_spinner "$?"
			fi
		fi
	done
else
	for package in $@; do # In case specific apps were given
		if [ -d $package ]; then
			if [ -n "$(docker images $package:latest | grep $package)" ]; then
				start_spinner "[Docker-apps] -- Updating package: $package"
				sh -c "cd ./$package && docker build -t $package --pull --no-cache $NVIDIA. && ./build.sh $NVARG $VPN"  > build.log 2>&1
				stop_spinner "$?"
			else
				echo "Package $package is not Installed !"
			fi
		else
			echo "Package $package is not available !"
		fi
	done
fi

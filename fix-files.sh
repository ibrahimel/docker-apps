#!/bin/bash

source "./spinner.sh"
echo '[Docker-apps] -- Preparing to Fix packages'

cd build/

# Fix files
list=$(ls)

# Fix icons and desktop shortcuts
for package in $list; do
	if [ -d $package ]; then
		start_spinner "[Docker-apps] -- Fixing package: $package" && echo 'Starting'

		#sed -i 's@apt-get@apt@' ./$package/Dockerfile && echo 'Dockerfile APT Done'
		#sed -i 's@apt-get@apt@' ./$package/nvidia.Dockerfile && echo 'nvidia Dockerfile APT Done'

		PNG=$(cat ./$package/build.sh | grep 'docker cp' | grep '.png')
		if [ -n "$PNG" ]; then
			rm -r ./$package/*.png && echo 'PNG Clean Done'
		fi

		ICO=$(cat ./$package/build.sh | grep 'docker cp' | grep '.ico')
		if [ -n "$ICO" ]; then
			rm -r ./$package/*.ico && echo 'ICO Clean Done'
		fi

		SVG=$(cat ./$package/build.sh | grep 'docker cp' | grep '.svg')
		if [ -n "$SVG" ]; then
			rm -r ./$package/*.svg && echo 'SVG Clean Done'
		fi

		XPM=$(cat ./$package/build.sh | grep 'docker cp' | grep '.xpm')
		if [ -n "$XPM" ]; then
			rm -r ./$package/*.xpm && echo 'XPM Clean Done'
		fi

		DESK=$(cat ./$package/build.sh | grep 'docker cp' | grep '.desktop')
		if [ -n "$DESK" ]; then
			rm -r ./$package/*.desktop && echo 'DESK Clean Done'
		fi

		#VPN=$(cat ./$package/build.sh | grep 'docker-apps-vpn')
		#if [ -n "$VPN" ]; then
		#	sed -i 's@RUNTIME=""@RUNTIME=""\n\nif [ "$1" = "--tor" ] || [ "$2" = "--tor" ]; then\n\tAPP="docker-apps-tor"\nfi@' ./$package/build.sh
		#fi

		stop_spinner $? && echo 'Done'
	fi
done

rm -rf ./vpn-router/ovpn/*

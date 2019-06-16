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

		PNG=$(cat ./$package/build.sh | grep 'docker cp' | grep "$package.png")
		if [ -n "$PNG" ]; then
			if [ -f ./$package/$package.png ]; then
				rm -r ./$package/*.png && echo 'PNG Clean Done'
			fi
		fi

		ICO=$(cat ./$package/build.sh | grep 'docker cp' | grep "$package.ico")
		if [ -n "$ICO" ]; then
			if [ -f ./$package/$package.ico ]; then
				rm -r ./$package/*.ico && echo 'ICO Clean Done'
			fi
		fi

		SVG=$(cat ./$package/build.sh | grep 'docker cp' | grep "$package.svg")
		if [ -n "$SVG" ]; then
			if [ -f ./$package/$package.svg ]; then
				rm -r ./$package/*.svg && echo 'SVG Clean Done'
			fi
		fi

		XPM=$(cat ./$package/build.sh | grep 'docker cp' | grep "$package.xpm")
		if [ -n "$XPM" ]; then
			if [ -f ./$package/$package.xpm ]; then
				rm -r ./$package/*.xpm && echo 'XPM Clean Done'
			fi
		fi

		DESK=$(cat ./$package/build.sh | grep 'docker cp' | grep "$package.desktop")
		if [ -n "$DESK" ]; then
			if [ -f ./$package/$package.desktop ]; then
				rm -r ./$package/*.desktop && echo 'DESK Clean Done'
			fi
		fi

		#VPN=$(cat ./$package/build.sh | grep 'docker-apps-vpn')
		#if [ -n "$VPN" ]; then
		#	sed -i 's@RUNTIME=""@RUNTIME=""\n\nif [ "$1" = "--tor" ] || [ "$2" = "--tor" ]; then\n\tAPP="docker-apps-tor"\nfi@' ./$package/build.sh
		#fi

		stop_spinner $? && echo 'Done'
	fi
done

rm -rf ./vpn-router/ovpn/*

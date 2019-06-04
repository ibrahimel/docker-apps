#!/bin/sh

echo '[Docker-apps] -- Preparing to Fix packages'
cd build/
# Fix files
list=$(ls)
for package in $list; do
	if [ -d $package ]; then
		echo "[Docker-apps] -- Fixing package: $package"
		PNG=$(cat ./$package/build.sh | grep 'docker cp' | grep '.png')
		if [ -n "$PNG" ]; then
			rm -r ./$package/*.png
		fi
		ICO=$(cat ./$package/build.sh | grep 'docker cp' | grep '.ico')
		if [ -n "$ICO" ]; then
			rm -r ./$package/*.ico
		fi
		SVG=$(cat ./$package/build.sh | grep 'docker cp' | grep '.svg')
		if [ -n "$SVG" ]; then
			rm -r ./$package/*.svg
		fi
		XPM=$(cat ./$package/build.sh | grep 'docker cp' | grep '.xpm')
		if [ -n "$XPM" ]; then
			rm -r ./$package/*.xpm
		fi
		DESK=$(cat ./$package/build.sh | grep 'docker cp' | grep '.desktop')
		if [ -n "$DESK" ]; then
			rm -r ./$package/*.desktop
		fi
	fi
done

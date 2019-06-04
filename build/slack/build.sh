#!/bin/sh

#Build Container
docker build --pull -t slack . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name slack slack

# Copy .desktop and icon files
docker cp slack:/usr/share/applications/slack.desktop ./
docker cp slack:/usr/share/pixmaps/slack.png ./

# Remove container
docker rm --force slack

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn slack@" slack.desktop
sed -i 's@TryExec.*@@' slack.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/slack/slack.png@" slack.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v slack.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/slack.desktop

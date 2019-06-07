#!/bin/sh

#Build Container
docker build --pull -t hashcat . && echo 'Done'

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps hashcat '-it --runtime=nvidia'@" hashcat.desktop &&
sed -i 's@TryExec.*@@' hashcat.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/hashcat/hashcat.png@" hashcat.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v hashcat.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/hashcat.desktop

![](https://www.docker.com/sites/default/files/social/docker_facebook_share.png)                              ![](https://cdn0.iconfinder.com/data/icons/tab-bar-ios-and-wp8-vector-icons/48/layers-256.png)

## **Docker-apps**

This repository contains dockerized applications and services for use with the desktop. An optional VPN or Tor router for each app and support for NVIDIA runtime in Ubuntu (see [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) for more details). The install scripts will also add .desktop files and launcher scripts to facilitate the integration for an easy execution with localized, isolated and minimal footprint on the system.


#### **Prerequisites**

The file `prereqs-nvidia.sh` will install `docker-ce` in Ubuntu 18.04+ and if it detects and NVIDIA driver it will also install `nvidia-docker` runtime.

If your dot not intend to use the nvidia runtime just make sure docker is installed and your current user is part of the docker group (these apps will not work if you have to use sudo for docker and are not intended to be run as root)

To use the VPN router with apps you need `.ovpn` files from your provider using the UDP protocol ports 80/443/5060/1194. If your configuration differ please update `entrypoint.sh` and `iptables.rules` in `build/vpn-router`.



#### **Configuration**

To install the scripts execute the following from your home folder:

`git clone https://github.com/ibrahimel/docker-apps .docker-apps`

`cd ~/.docker-apps`

In the base folder some scripts are available and can do the following:

<u>**Install usage:**</u> `./install.sh [--vpn] [--tor] [--nvidia] [--all] app1 app2 app3`

The install script accepts options and take app names as arguments:

`--all` This will install all available apps in the`build/` folder. Unwanted apps can be added to the `.buildignore` file and will be ignored during installation.

`--vpn` This will configure all desktop shortcuts to use the VPN wrapper (explained below).

`--tor` This will configure all desktop shortcuts to use the Tor network.

`--nvidia` This will configure all desktop shortcuts to use the NVIDIA Docker runtime (provided it is installed before-hand).

Log output for the build scripts is in `build/build.log` and and you can check live the build process from a terminal: `tail -f ~/.docker-apps/build/build.log`.

<u>**Update usage**:</u> `./update.sh [--vpn] [--tor] [--nvidia] [--all] app1 app2 app3`

Same options and arguments as the install script. This will pull updated images for the apps and re-install packages to their latest version. It will only act on already installed images.

<u>**Uninstall usage**:</u> `./uninstall [--all] app1 app2 app3`

The uninstall script takes apps as arguments or the `--all` options can be specified to delete all installed apps. You will be prompted whether to keep persistent container data or not.

<u>*Examples:*</u>

`./install.sh --all --nvidia # Install all apps with nvidia runtime`

`echo 'atom virtualbox thunderbird-proton' >> .buildignore && ./install.sh --all --vpn # Ignore Some apps and install the rest with vpn support`

`./update --nvidia steam # Update steam and run with Nvidia`

`./uninstall --all # Clean everything`



#### **Structure and folders**

**<u>Bin folder:</u>**

This folder contains launcher scripts that are used by the `.desktop` files.

`docker-apps`: This is the default script. It will run the container as a normal user, share necessary ENV variables, X11 and PulseAudio socket and DBus for most applications to work. It will create an isolated home folder for the container image in `~/.docker-apps/homes/app` and the Downloads folder in the container is shared from `~/Downloads/docker-apps/app`.

`docker-apps-vpn`: Before launching the app as docker-apps does it, it will spawn a new vpn-router container and make the app container use it's network.

`docker-apps-tor`: Just like the vpn script but instead of a `vpn router`, it creates a `tor-router`

All scripts have the `*-disposable` variant which will not share home or download folders with the containers. Data will not persist on those containers.

Each script accepts two arguments: 

`docker-apps* app '[args]'` app is the app name and args are all additional arguments to pass to `docker run` and must be wrapped in quotes to  be considered as one argument.

For example: `docker-apps-vpn firefox '--shm-size 2g --entrypoint bash -it'`

<u>**Build folder**</u>:

This folder contains one folder per app. The names of the folders are the ones to be used as arguments for the scripts.

Each app folder contains at least the following:

`Dockerfile`: The docker build file for the app. All builds are tested on Ubuntu, Debian and Arch before being pushed.

`nvidia.Dockerfile` This docker file will be used if you passed the --nvidia argument.

`build.sh` This file is the one called by the install script and contains default options for running the applications. You can customize all options pertaining to the `.desktop` file (for example add the `-v /path/to/folder/on/host:/path/to/folder/on/container` to share a folder or any argument parsable by `docker run`)

`app.desktop` When the desktop file can't be copied from the image, a hard-coded base file is available. Same for `app.png` for app icons.

`entrypoint.sh`  Entry-point script for the container when needed.

Some additional files may be present depending on the app. (`.deb` files or `iptables.rules` for example)



#### **Additional details**

To use the `--vpn` option you must edit `build/vpn-router/entrypoint.sh` with your VPN credentials and put your `ovpn` files in the `build/vpn-router/ovpn` folder. Also edit `bin/docker-apps-vpn` with your provider DNS and fallback DNS (currently set to `1.1.1.1` ).

To use the `--nvidia` option please make-sure Nvidia runtime is enabled in /etc/docker/daemon.json and that it is working. You can test it by running  `docker run --runtime=nvidia -it nvidia/cuda nvidia-smi`

Most applications run without additional privileges except a few:

- Wireshark need host net access and NET_ADMIN capability
- Portainer needs access to docker socket and thus must be run as root
- Vpn-routers and tor-routers need elevated privileges to be able to restore ip-tables for their network
- Virtuabox needs elevated privileges
- Kali linux is a full Kali install and default user is added with NOPASSWD in sudoers file
- Zoom-us uses `/dev/video` for access to webcam

Also:

- Portainer, Netflix and Tensorflow Jupyter are wrapped by Electron NodeJs to make them available as GUI Apps
- Thunderbird ProtonMail: Protonmail needs to be configured after first run from an attached terminal using `docker exec -it name_of_container protonmail-bridge --cli`
- Dev Apps (Atom, Sublime, VS Code etc.) will share the user's `.ssh .gnupg .gitconfig workspace` folders from home to enable signing commits in git and pull / push from repo using ssh and edit projects in ~/workspace. This default behavior can be edit in the app's `build.sh` file.
- All Dockerfiles share the same base more than necessary to run GUI apps and most of them use `ubuntu:18.04` base-image or `nvidia/opengl:ubuntu-18.04` for nvidia runtime. This will speed up bulk installs as most layers will already be cached.

Try not to install applications that are already installed on your system as XDG gets confused and may launch any of the two randomly. Also Virtualbox cannot be installed on-top of an existing bare-metal install.



#### **How to contribute**

- To report a bug or suggest additions don't hesitate to create an issue.
- To add new images please fork the project, add the images by copying one of the existing ones and follow same architecture to make in installable by the scripts and create a pull request.



#### **Credits and related work**

- Jessie Frazelle [dockerfiles](https://github.com/jessfraz/dockerfiles) repository
- [x11docker](https://github.com/mviereck/x11docker) by mviereck
- Nvidia Docker [runtime](https://github.com/NVIDIA/nvidia-docker)
- [Nativefier](https://github.com/jiahaog/nativefier) for Electron
- Castlabs [Electron](https://github.com/castlabs/electron-releases) with Widevine support




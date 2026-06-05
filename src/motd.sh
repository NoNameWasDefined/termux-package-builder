#!/system/bin/sh
# shellcheck disable=SC2016

arch=$(uname -m)
printf '
Welcome to Termux Docker for %s!
This image was modified from %s for ease with package building
Last image update: %s

Example quickstart:
Clone termux-packages repo (preferably as UID %s)
	`git clone https://github.com/termux/termux-packages.git`
Create a container with a custom name and mount the cloned repo and build output
	`docker run -it --name termux-package-builder -v $PWD:termux-packages:$HOME/termux-packages -v $PWD/termux-build:$HOME/.termux-build %s`
Inside the container try a build of Mesa with your modifications
	`cd termux-packages`
	`./build-package.sh -I mesa`
Exit the container and do stuff in the build source
	`find termux-build -name %s*test*%s`
Rerun the build in the container
	`docker start -ia termux-package-builder sh -c %scd termux-packages; ./build-package.sh -I mesa%s`
Delete the container and build folder, built packages won%st be lost
	`docker rm termux-package-builder`
	`rm -rf termux-build`
Push built packages to your device
	`adb push termux-packages/mesa_*_%s.deb`
An helper script to manage these containers will be written soon

Please note that it cannot do cross-compiling and the flag `-i` cannot be used in favor of the `-I` flag!
' "$arch" "$TERMUX__ORIGIN_IMAGE" "$(id -u)" "$TERMUX__IMAGE_BUILD_DATE" "$TERMUX__CURRENT_IMAGE" "'" "'" "'" "'" "'" "$arch"

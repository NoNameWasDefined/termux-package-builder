# termux-package-builder

A Docker image to replace the official "ghcr.io/termux/package-builder" image for unsupported devices, based on termux/termux-docker

## About

Currently just the termux/termux-docker image with all development packages installed, the official mirror (non-CF) set as the only mirror to always have the latest packages, and a custom MOTD.

## Usage

Requirements:
- Docker

Pull the image:
```sh
docker pull ghcr.io/nonamewasdefined/termux-package-builder
```
Run a container with a mounted volume to termux/termux-packages and build something inside it:
```sh
docker run -it --rm -v ~/termux-packages:/data/data/com.termux/files/home/termux-packages -w /data/data/com.termux/files/home/termux-packages ghcr.io/nonamewasdefined/termux-package-builder ./build-package.sh -I mesa
```

Push the built package to your device:
```sh
adb push ~/termux-packages/output/mesa_*_*.deb /storage/emulated/0/Download
```

Install your package on your device:
```sh
pkg install /storage/emulated/0/Download/mesa_*_*.deb
```

> An helper script will be available soon to simplify the process by:
> - automating package updates and container cleanup
> - managing a global cache to avoid redundant steps during builds, like package downloads or building
>
> It will also allow cleaner builds by not keeping files installed in the environment

## Building

> The Docker BuildKit plugin is needed, search how to install it on your distro

You can build the image using the Dockerfile, Podman is not tested yet.
```sh
docker buildx build --tag ghcr.io/nonamewasdefined/termux-package-builder --build-arg IMAGE_BUILD_DATE="$(date --utc)" src
```
- To change the architecture you can use Docker's `--platform` flag to specify another target
- Always specify `$IMAGE_BUILD_DATE` with the current UTC date
- To build against another image than "termux/termux-docker", specify the argument `ORIGIN_IMAGE_NAME` with the image tag
- If you change the tag name you will have to specify the argument `TARGET_IMAGE_NAME` with the tag name else it will use "ghcr.io/NoNameWasDefined/termux-package-builder"
- APT cache is cached by BuildKit, using the flags `--cache-from` and `--cache-to` you can mount the cache in a locam directory to reuse the packages in a container

# termux-package-builder

A Docker image to replace the official "ghcr.io/termux/package-builder" image for unsupported devices, based on termux/termux-docker

## What is it?

Currently just the termux/termux-docker image with all development packages installed, the official mirror (non-CF) set as the only mirror to always have the latest packages, and a custom MOTD.

## How to use this?

> The Docker BuildKit plugin is needed, search how to install it on your distro

You can build the image using the Dockerfile, Podman is not tested yet.
```sh
docker buildx build --tag ghcr.io/NoNameWasDefined/termux-package-builder src
```
- To change the architecture you can use Docker's `--platform` flag to specify another target
- To build against another image than "termux/termux-docker", specify the argument `ORIGIN_IMAGE_NAME` with the image tag
- If you change the tag name you will have to specify the argument `TARGET_IMAGE_NAME` with the tag name else it will use "ghcr.io/NoNameWasDefined/termux-package-builder"
- APT cache is cached by BuildKit, using the flags `--cache-from` and `--cache-to` you can mount the cache in a locam directory to reuse the packages in a container

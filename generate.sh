#!/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

: "${TERMUX_DOCKER__NAME:=termux/termux-docker}"
: "${TERMUX_DOCKER__ARCH:=$(uname --machine)}"
: "${TERMUX_DOCKER__PACKAGE_BUILDER_NAME:=localhost.local/termux/termux-package-builder}"
TERMUX_DOCKER__BUILDER='linux/'

case "${TERMUX_DOCKER__ARCH}" in
aarch64 | arm64)
	TERMUX_DOCKER__BUILDER+='arm64'
	: 'aarch64' ;;
arm | armhf | armv7l | armv8l)
	TERMUX_DOCKER__BUILDER+='arm'
	: 'arm' ;;
i386 | i686 | x86)
	TERMUX_DOCKER__BUILDER+='i386'
	: 'i686' ;;
amd64 | x86_64)
	TERMUX_DOCKER__BUILDER+='amd64'
	: 'x86_64' ;;
*) # ARMv6 is unsupported too
	printf "Unsupported machine \"%s\".\nIf you think your \`uname -m\` reports a strange name, you can override \`$TERMUX_DOCKER__ARCH\` with one of aarch64, arm, i686 and x86_64\n" "${TERMUX_DOCKER__ARCH}" 1>&2
	exit 1
	;;
esac
TERMUX_DOCKER__ARCH="$_"

# Detect if user is able to interact with Docker without sudo
SUDO=""
if [[ "$(uname)" = "Linux" ]] && (( "$(id -u)" != 0 )) && [[ "$(id -Gn)" != *" docker "* ]]; then
	SUDO="sudo"
fi

cd "$(dirname "$0")/src"

sed \
	--expression="s/%TERMUX_ARCH%/${TERMUX_DOCKER__ARCH}/g" \
	--expression="s/%BUILD_DATE%/$(LC_ALL=C date --utc
)/g" \
	--expression="s/%IMAGE_NAME%/${TERMUX_DOCKER__PACKAGE_BUILDER_NAME//\//\\\/}/g" \
'motd.sh.in' > 'motd.sh'

$SUDO docker buildx build \
	--build-arg "TERMUX_DOCKER_TAG=${TERMUX_DOCKER__NAME}:${TERMUX_DOCKER__ARCH}" \
	--platform "${TERMUX_DOCKER__BUILDER}" \
	--tag "${TERMUX_DOCKER__PACKAGE_BUILDER_NAME}:${TERMUX_DOCKER__ARCH}" \
	"$@" \
	.

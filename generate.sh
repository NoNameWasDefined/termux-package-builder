#!/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

: "${TERMUX_DOCKER__ORIGIN_IMAGE_TAG:=termux/termux-docker}"
: "${TERMUX_DOCKER__FINAL_IMAGE_TAG:=localhost.local/termux/termux-package-builder}"

# Detect if user is able to interact with Docker without sudo
SUDO=""
if [[ "$(uname)" = "Linux" ]] && (("$(id -u)" != 0)) && [[ "$(id -Gn)" != *" docker "* ]]; then
	SUDO="sudo"
fi

cd "$(dirname "$0")/src"

# Replace placeholders surrouded by % with actual values
sed \
	--expression="s/%BUILD_DATE%/$(
		LC_ALL=C date --utc
	)/g" \
	--expression="s/%IMAGE_TAG%/${TERMUX_DOCKER__FINAL_IMAGE_TAG//\//\\\/}/g" \
	'motd.sh.in' >'motd.sh'

arguments=("$@")
arguments+=('--build-arg' "TERMUX_DOCKER_TAG=${TERMUX_DOCKER__ORIGIN_IMAGE_TAG}")
arguments+=('--tag' "${TERMUX_DOCKER__FINAL_IMAGE_TAG}")

if [[ -v TERMUX_DOCKER__BUILDER_PLATFORM ]]; then
	arguments+=('--platform' "${TERMUX_DOCKER__BUILDER_PLATFORM}")
fi

arguments+=('.')

$SUDO docker buildx build "${arguments[@]}"

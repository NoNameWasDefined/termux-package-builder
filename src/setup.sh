#!/system/bin/sh

set -o errexit
set -o nounset

mkdir -p '/data/data/com.termux/cache/apt/archives/partial'
ln --symbolic --relative --force \
	"$PREFIX/etc/termux/mirrors/europe/packages.termux.dev" \
	"$PREFIX/etc/termux/chosen_mirrors"
pkg upgrade --assume-yes --quiet --option=Dpkg::Options::=--force-confnew
apt install --assume-yes --quiet git gnupg jq

ln --symbolic --relative --force \
	"$PREFIX/etc/termux/mirrors/europe/packages.termux.dev" \
	"$PREFIX/etc/termux/chosen_mirrors"
pkg --check-mirror upgrade

sed --in-place \
	--expression="s/%BUILD_DATE%/$(
		date --utc
	)/g" \
	--expression="s/%ORIGIN_IMAGE_TAG%/$1/g" \
	--expression="s/%ACTUAL_IMAGE_TAG%/$1/g" \
	"$HOME/.termux/motd.sh"

if [ -z "$(find /source -mindepth 1 -print0 -quit)" ]; then
	git clone --depth=1 'https://github.com/termux/termux-packages.git' '/source'
else
	git -C '/source' pull
fi

cd '/source'
'./scripts/setup-termux.sh'

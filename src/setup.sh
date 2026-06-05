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

cd '/source'

if [ -z "$(find /source -mindepth 1 -print0 -quit)" ]; then
	git init
	git remote add origin 'https://github.com/termux/termux-packages.git'
fi
git fetch --depth=1 origin master
git reset --hard origin/master

'./scripts/setup-termux.sh'

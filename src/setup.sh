#!/system/bin/sh
set -o errexit
set -o nounset

mkdir -p '/data/data/com.termux/cache/apt/archives/partial'
ln --symbolic --relative --force \
	"${PREFIX}/etc/termux/mirrors/europe/packages.termux.dev" \
	"${PREFIX}/etc/termux/chosen_mirrors"
pkg upgrade --assume-yes --quiet --option=Dpkg::Options::=--force-confnew
apt install --assume-yes --quiet gnupg jq

ln --symbolic --relative --force \
        "${PREFIX}/etc/termux/mirrors/europe/packages.termux.dev" \
        "${PREFIX}/etc/termux/chosen_mirrors"
pkg --check-mirror upgrade

cd '/source'
'./scripts/setup-termux.sh'

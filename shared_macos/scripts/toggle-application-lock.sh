#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR
# shellcheck disable=SC2155

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"

source "$rootdir/shared/scripts/helper.sh"
trap trap_error ERR

action=""
while [[ $# -gt 0 ]]; do case $1 in
	--lock)
		action="lock";
		shift;;
	--unlock)
		action="unlock";
		shift;;
	*)
		shift;;
esac; done

apps_list=(
	"Brave Browser"
	"Google Chrome"
	"Visual Studio Code"
	"Signal"
	"WhatsApp"
	"Zed"
)

[ "$action" != "lock" ] && [ "$action" != "unlock" ] &&
	echo "Error: No specific action was select: --lock/--unlock." &&
	exit 1

[ "$action" == "lock" ] &&
	sflags="schange" && uflags="uchange" &&
	echo "-> Locking applications ..."
[ "$action" == "unlock" ] &&
	sflags="noschange" && uflags="nouchange" &&
	echo "-> Unlocking applications ..."

for item in "${apps_list[@]}"; do
	app="/Applications/${item}.app"
	if [ -d "$app" ]; then
		echo -e "\t-> ${action}ing $item ..."
		sudo chflags -R "$sflags" "/Applications/${item}.app"
		chflags -R "$uflags" "/Applications/${item}.app"
	fi
done

echo "-> All done!"

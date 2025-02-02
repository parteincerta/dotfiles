#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"

source "$rootdir/shared/scripts/helper.sh"
trap trap_error ERR

vsc_data_dir="$XDG_CACHE_HOME/code/data/"
vsc_extensions_dir="$XDG_CACHE_HOME/code/extensions/"
if [ "$1" = "--plugins-list" ] && [ -s "$2" ]; then
	vsc_extensions_list=$(cat "$2")
else
	vsc_extensions_list=$(cat "$rootdir/shared/scripts/install-vscode-plugins-list.txt")
fi

for extension in $vsc_extensions_list
do
	extension_author=${extension%%*.}
	extension_name=${extension##*.}
	echo -e "\t-> Installing $extension_name of $extension_author"
	code \
		--user-data-dir "$vsc_data_dir" \
		--extensions-dir "$vsc_extensions_dir" \
		--install-extension "$extension" \
		--force &>/dev/null
done

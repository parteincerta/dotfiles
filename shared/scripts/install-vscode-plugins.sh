#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"

source "$rootdir/shared/scripts/helper.sh"
trap trap_error ERR

plugins_list=""
silent=""
while [[ $# -gt 0 ]]; do case $1 in
	--plugins-list)
		plugins_list="$2";
		shift;;
	--silent)
		silent="yes";
		shift;;
	*)
		shift;;
esac; done

vsc_data_dir="$XDG_CACHE_HOME/code/data/"
vsc_extensions_dir="$XDG_CACHE_HOME/code/extensions/"
vsc_extensions_list_file="${TMPDIR}install-vscode-plugins-list.txt"

if [ ! -f "$vsc_extensions_list_file" ]; then
	[ -n "$plugins_list" ] &&
		vsc_extensions_list=$(cat "$plugins_list") ||
		vsc_extensions_list=$(cat "$rootdir/shared/scripts/install-vscode-plugins-list.txt")
	echo "$vsc_extensions_list" >"$vsc_extensions_list_file"
else
	vsc_extensions_list=$(cat "$vsc_extensions_list_file")
fi

for extension in $vsc_extensions_list
do
	extension_author=${extension%%*.}
	extension_name=${extension##*.}
	echo -e "\t-> Installing $extension_name of $extension_author"
	_run code \
		--user-data-dir "$vsc_data_dir" \
		--extensions-dir "$vsc_extensions_dir" \
		--install-extension "$extension" \
		--force

	# Remove the last extension that was successfully installed so it won't be
	# reprocessed when the script it re-executed after a failure.
	sed -i '' '1d' "$vsc_extensions_list_file"

done

rm "$vsc_extensions_list_file"

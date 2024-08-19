# vim:ft=bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"
this_script_abs_path="$(cd $this_script_rel_path >/dev/null && pwd)"

set -e
source "$this_script_rel_path/helper.sh"
trap trap_error ERR

vsc_data_dir="$XDG_CACHE_HOME/code/data/"
vsc_extensions_dir="$XDG_CACHE_HOME/code/extensions/"
if [ "$1" = "--plugins-list" ] && [ -s "$2" ]; then
	vsc_extensions_list=$(cat "$2")
else
	vsc_extensions_list=$(cat "$this_script_abs_path/install-vscode-plugins-list.txt")
fi

for extension in $vsc_extensions_list
do
	extension_author=${extension##*.}
	extension_name=${extension##*.}
	echo -e "\t-> Installing $extension_name"
	code \
		--user-data-dir "$vsc_data_dir" \
		--extensions-dir "$vsc_extensions_dir" \
		--install-extension "$extension" \
		--force &>/dev/null
done

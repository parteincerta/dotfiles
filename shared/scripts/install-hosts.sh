# vim:ft=bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"

set -e
source "$this_script_rel_path/helper.sh"
trap trap_error ERR
trap "rm -rf $TMPDIR/{hosts,hosts-additions}" EXIT

version="3.14.98"
url="https://raw.githubusercontent.com/StevenBlack/hosts/${version}/hosts"
system="$(uname -s)"

if [ "$system" = "Darwin" ]; then

	echo "-> Downloading StevenBlack's hosts v$version ..."
	curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
		-L -sS -H "Accept:application/vnd.github.v3.raw" "$url" \
		-o "$TMPDIR"/hosts

	echo "-> Applying additions ..."
	# ------------------------------

	hosts_additions_orig="$this_script_rel_path/install-hosts-additions.json"
	hosts_additions_subst="$TMPDIR/hosts-additions"
	export hostname="${1:-${HOSTNAME%.*}}"
	envsubst <"$hosts_additions_orig" >"$hosts_additions_subst"

	echo -e "\n# START --- General additions" >>"$TMPDIR/hosts"
	shared_address_list=$(jq -r ".shared | keys[]" "$hosts_additions_subst")
	for addr in ${shared_address_list[*]}; do
		shared_names_list=$(jq -r ".shared[\"$addr\"][]" "$hosts_additions_subst")
		for name in ${shared_names_list[*]}; do
			echo -e "$addr $name" >>"$TMPDIR/hosts"
		done
	done
	echo -e "# END --- General additions" >>"$TMPDIR/hosts"

	if [ -n "$1" ]; then
		echo -e "\n# START --- Specific additions for $1" >>"$TMPDIR/hosts"
		specific_address_list=$(jq -r ".specific.$1 // {} | keys[]" "$hosts_additions_subst")
		for addr in ${specific_address_list[*]}; do
			specific_names_list=$(jq -r ".specific.$1[\"$addr\"][]" "$hosts_additions_subs")
			for name in ${specific_names_list[*]}; do
				echo -e "$addr $name" >>"$TMPDIR/hosts"
			done
		done
		echo -e "# END --- Specific additions for $1" >>"$TMPDIR/hosts"
	fi

	echo "-> Applying exclusions ..."
	# -------------------------------

	shared_address_list=$(jq -r '.shared | join(" ")' "$this_script_rel_path/install-hosts-exclusions.json")
	for name in ${shared_address_list[*]}; do
		sed -i -r "/^$name/s//#&/g" "$TMPDIR/hosts"
	done

	if [ -n "$1" ]; then
		specific_address_list=$(jq -r ".specific.$1 // [] | join(\" \")" "$this_script_rel_path/install-hosts-exclusions.json")
		for name in ${specific_address_list[*]}; do
			sed -i -r "/^$name/s//#&/g" "$TMPDIR/hosts"
		done
	fi

	echo "-> Setting new /private/etc/hosts ..."
	sudo mv "$TMPDIR"/hosts /private/etc/hosts

elif [ "$system" = "Linux" ]; then
	#TODO
	:
fi

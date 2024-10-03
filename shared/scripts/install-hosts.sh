#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"
trap 'rm -rf $TMPDIR/hosts*' EXIT

source "$rootdir/shared/scripts/helper.sh"
trap 'trap_error;rm -rf $TMPDIR/hosts*' ERR

version="3.14.114"
url="https://raw.githubusercontent.com/StevenBlack/hosts/${version}/alternates/gambling-porn-social/hosts"
system="$(uname -s)"

if [ "$system" = "Darwin" ]; then

	echo "-> Downloading StevenBlack's hosts v$version ..."
	curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
		-L -sS -H "Accept:application/vnd.github.v3.raw" "$url" \
		-o "$TMPDIR/hosts"

	echo "-> Applying additions ..."
	# ------------------------------

	hosts_additions_orig="$rootdir/shared/scripts/install-hosts-additions.json"
	hosts_additions_subst="${TMPDIR}hosts-additions.json"
	export hostname="${1:-${HOSTNAME%.*}}"
	envsubst <"$hosts_additions_orig" >"$hosts_additions_subst"

	echo -e "\n# START --- General additions" >>"$TMPDIR/hosts"
	shared_address_list=$(jq -r ".shared | keys[]" "$hosts_additions_subst")
	for addr in "${shared_address_list[@]}"; do
		shared_names_list=$(jq -r ".shared[\"$addr\"][]" "$hosts_additions_subst")
		for name in "${shared_names_list[@]}"; do
			echo -e "$addr $name" >>"$TMPDIR/hosts"
		done
	done
	echo -e "# END --- General additions" >>"$TMPDIR/hosts"

	if [ -n "$1" ]; then
		echo -e "\n# START --- Specific additions for $1" >>"$TMPDIR/hosts"
		specific_address_list=$(jq -r ".specific.$1 // {} | keys[]" "$hosts_additions_subst")
		for addr in "${specific_address_list[@]}"; do
			if [ -z "$addr" ]; then continue; fi
			specific_names_list=$(jq -r ".specific.$1[\"$addr\"][]" "$hosts_additions_subst")
			for name in "${specific_names_list[@]}"; do
				echo -e "$addr $name" >>"$TMPDIR/hosts"
			done
		done
		echo -e "# END --- Specific additions for $1" >>"$TMPDIR/hosts"
	fi

	echo "-> Applying exclusions ..."
	# -------------------------------

	shared_address_list=$(jq -r '.shared | join(" ")' "$rootdir/shared/scripts/install-hosts-exclusions.json")
	for name in $shared_address_list; do
		if [ -z "$name" ]; then continue; fi
		sed -i '' -r "/$name/s//# &/" "$TMPDIR/hosts"
	done

	if [ -n "$1" ]; then
		specific_address_list=$(jq -r ".specific.$1 // [] | join(\" \")" "$rootdir/shared/scripts/install-hosts-exclusions.json")
		for name in $specific_address_list; do
			if [ -z "$name" ]; then continue; fi
			sed -i '' -r "/^$name/s//#&/" "$TMPDIR/hosts"
		done
	fi

	echo "-> Setting new /private/etc/hosts ..."
	sudo mv "$TMPDIR/hosts" /private/etc/hosts

elif [ "$system" = "Linux" ]; then
	#TODO
	:
fi

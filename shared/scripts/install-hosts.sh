#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"
trap 'rm -rf $TMPDIR/hosts*' EXIT

source "$rootdir/shared/scripts/helper.sh"
trap 'trap_error;rm -rf $TMPDIR/hosts*' ERR

version="3.14.125"
url="https://raw.githubusercontent.com/StevenBlack/hosts/${version}/alternates/gambling-porn-social/hosts"
system="$(uname -s)"

if [ "$system" = "Darwin" ]; then

	echo "-> Downloading StevenBlack's hosts v$version ..."
	curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
		-L -sS -H "Accept:application/vnd.github.v3.raw" "$url" \
		-o "$TMPDIR/hosts"

	echo "-> Applying additions ..."

	hosts_additions_orig="$rootdir/shared/scripts/install-hosts-additions.json"
	hosts_additions_subst="${TMPDIR}hosts-additions.json"
	export hostname="${1:-${HOSTNAME%.*}}"
	envsubst <"$hosts_additions_orig" >"$hosts_additions_subst"

	echo "" >>"$TMPDIR/hosts"
	echo "# START --- General additions" >>"$TMPDIR/hosts"
	mapfile -d '' shared_address_list < \
		<(jq --raw-output0 '.shared | keys[]' "$hosts_additions_subst")
	for addr in "${shared_address_list[@]}"; do
		mapfile -d '' shared_names_list < \
			<(jq --raw-output0 ".shared[\"$addr\"][]" "$hosts_additions_subst")
		for name in "${shared_names_list[@]}"; do
			echo "$addr $name" >>"$TMPDIR/hosts"
		done
	done
	echo "# END --- General additions" >>"$TMPDIR/hosts"

	if [ -n "$1" ]; then
		echo "" >>"$TMPDIR/hosts"
		echo "# START --- Specific additions for $1" >>"$TMPDIR/hosts"
		mapfile -d '' specific_address_list < \
			<(jq --raw-output0 ".specific.$1 | keys[]" "$hosts_additions_subst")
		for addr in "${specific_address_list[@]}"; do
			if [ -z "$addr" ]; then continue; fi
			mapfile -d '' specific_names_list < \
				<(jq --raw-output0 ".specific.$1[\"$addr\"][]" \
					"$hosts_additions_subst")
			for name in "${specific_names_list[@]}"; do
				echo "$addr $name" >>"$TMPDIR/hosts"
			done
		done
		echo "# END --- Specific additions for $1" >>"$TMPDIR/hosts"
	fi

	echo "-> Applying exclusions ..."

	mapfile -d '' shared_address_list < \
		<(jq --raw-output0 '.shared[]' \
			"$rootdir/shared/scripts/install-hosts-exclusions.json")
	for name in "${shared_address_list[@]}"; do
		if [ -z "$name" ]; then continue; fi
		echo -e "\t-> Excluding $name ..."
		sed -i '' -r "/$name/s//# &/" "$TMPDIR/hosts"
	done

	if [ -n "$1" ]; then
		mapfile -d '' specific_address_list < \
			<(jq --raw-output0 ".specific.$1[]" \
				"$rootdir/shared/scripts/install-hosts-exclusions.json")
		for name in "${specific_address_list[@]}"; do
			if [ -z "$name" ]; then continue; fi
			echo -e "\t-> Excluding $name ..."
			sed -i '' -r "/$name/s//# &/" "$TMPDIR/hosts"
		done
	fi

	echo "-> Setting new /private/etc/hosts ..."
	sudo mv "$TMPDIR/hosts" /private/etc/hosts

elif [ "$system" = "Linux" ]; then
	#TODO
	:
fi

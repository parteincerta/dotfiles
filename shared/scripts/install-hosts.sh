#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR
# shellcheck disable=SC2207

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"
trap 'rm -rf $TMPDIR/hosts*' EXIT

source "$rootdir/shared/scripts/helper.sh"
trap 'trap_error; rm -rf $TMPDIR/hosts*' ERR

system="$(uname -s)"
version="3.15.16"
url="https://raw.githubusercontent.com/StevenBlack/hosts/${version}/alternates/gambling-porn-social/hosts"
user_defined_hostname=""

parse_arguments () {
	while [[ $# -gt 0 ]]; do case $1 in
		--basic)
			url="https://raw.githubusercontent.com/StevenBlack/hosts/${version}/hosts";
			shift;;
		--hostname)
			user_defined_hostname="$2";
			shift; shift;;
		*)
			shift;;
	esac; done
}
parse_arguments "${@}"

if [ "$system" = "Darwin" ]; then

	echo "-> Downloading StevenBlack's hosts v$version ..."
	curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
		-L -sS -H "Accept:application/vnd.github.v3.raw" "$url" \
		-o "$TMPDIR/hosts"

	echo "-> Applying additions ..."

	hosts_additions_orig="$rootdir/shared/scripts/install-hosts-additions.json"
	hosts_additions_subst="${TMPDIR}hosts-additions.json"
	export _hostname="${user_defined_hostname:-$SHORT_HOSTNAME}"
	envsubst <"$hosts_additions_orig" >"$hosts_additions_subst"

	echo "" >>"$TMPDIR/hosts"
	echo "# START --- General additions" >>"$TMPDIR/hosts"
	declare -a shared_address_list=($(
		jq --raw-output '.shared | keys[]' "$hosts_additions_subst" |
		tr "\n" " "
	))
	for addr in "${shared_address_list[@]}"; do
		declare -a shared_names_list=($(
			jq --raw-output ".shared[\"$addr\"][]" "$hosts_additions_subst" |
			tr "\n" " "
		))
		for name in "${shared_names_list[@]}"; do
			echo "$addr $name" >>"$TMPDIR/hosts"
		done
	done
	echo "# END --- General additions" >>"$TMPDIR/hosts"

	echo "" >>"$TMPDIR/hosts"
	echo "# START --- Specific additions for $_hostname" >>"$TMPDIR/hosts"
	declare -a specific_address_list=($(
		jq --raw-output ".specific.\"${_hostname}\" | keys[]" "$hosts_additions_subst" |
		tr "\n" " "
	))
	for addr in "${specific_address_list[@]}"; do
		if [ -z "$addr" ]; then continue; fi
		declare -a specific_names_list=($(
			jq --raw-output ".specific.\"$_hostname\"[\"$addr\"][]" "$hosts_additions_subst" |
			tr "\n" " "
		))
		for name in "${specific_names_list[@]}"; do
			echo "$addr $name" >>"$TMPDIR/hosts"
		done
	done
	echo "# END --- Specific additions for $_hostname" >>"$TMPDIR/hosts"

	echo "-> Applying exclusions ..."

	declare -a shared_address_list=($(
		jq --raw-output '.shared+.shared_extra|.[]' \
			"$rootdir/shared/scripts/install-hosts-exclusions.json" |
		tr "\n" " "
	))
	for name in "${shared_address_list[@]}"; do
		if [ -z "$name" ]; then continue; fi
		echo -e "\t-> Excluding $name ..."
		sed -i '' -r "/$name/s//# &/" "$TMPDIR/hosts"
	done

	declare -a specific_address_list=($(
		jq --raw-output ".specific.\"$_hostname\"[]" \
			"$rootdir/shared/scripts/install-hosts-exclusions.json" |
		tr "\n" " "
	))
	for name in "${specific_address_list[@]}"; do
		if [ -z "$name" ]; then continue; fi
		echo -e "\t-> Excluding $name ..."
		sed -i '' -r "/$name/s//# &/" "$TMPDIR/hosts"
	done

	echo "-> Setting new /private/etc/hosts ..."
	sudo mv "$TMPDIR/hosts" /private/etc/hosts

elif [ "$system" = "Linux" ]; then
	#TODO
	:
fi

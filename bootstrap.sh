#!/usr/bin/env bash
# shellcheck disable=SC1090

set -e

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
pushd "$scriptdir" >/dev/null
trap "popd >/dev/null" EXIT

os="$(uname -s)"

if [ "$os" = "Darwin" ]; then
	nice_hostname="${HOSTNAME/%.local/}"
	[[ $nice_hostname == macos13-ventura* ]] && nice_hostname="macos13-ventura"
	[[ $nice_hostname == macos14-sonoma* ]] && nice_hostname="macos14-sonoma"
	[[ $nice_hostname == macos15-sequoia* ]] && nice_hostname="macos15-sequoia"
	. "./macos/$nice_hostname/bootstrap.sh"
fi

#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR
# shellcheck disable=SC2155

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"

source "$rootdir/shared/scripts/helper.sh"
trap trap_error ERR

trap_exit () {
	rm -rf "${TMPDIR}mongodb"*
	rm -rf "${TMPDIR}mongosh"*
}
trap trap_exit EXIT

arch="$(uname -m)"
system="$(uname -s)"
mongo_sh_version="2.5.1"
mongo_tools_version="100.12.1"

if [ "$1" == "shell" ]; then

	# This could just be a simple `brew install mongosh` but it has an uncessary
	# dependecy on Node.js/NPM.
	if [ "$system" = "Darwin" ]; then

		if [ "$arch" = "x86_64" ]; then arch="x64"; fi
		url="https://downloads.mongodb.com/compass/mongosh-${mongo_sh_version}-darwin-${arch}.zip"

		echo "-> Downloading $url ..."
		curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
			--progress-bar -L -S "$url" -o "${TMPDIR}mongosh.zip"

		echo "-> Extracting ${TMPDIR}mongosh.zip ..."
		unzip "${TMPDIR}mongosh.zip" -d "$TMPDIR" >/dev/null

		echo "-> Installing in $HOME/.local/bin/ ..."
		rm -rf "$HOME/.local/bin/mongosh"
		mv "${TMPDIR}mongosh-${mongo_sh_version}-darwin-${arch}/bin/mongosh" "$HOME/.local/bin/"

		echo "-> Finished."

	elif [ "$system" = "Linux" ]; then
		# TODO
		:
	fi

elif [ "$1" == "tools" ]; then

	if [ "$system" = "Darwin" ]; then
		url="https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-${arch}-${mongo_tools_version}.zip"
		echo "-> Downloading $url ..."
		curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
			--progress-bar -L -S "$url" -o "${TMPDIR}mongodb-tools.zip"

		echo "-> Extracting ${TMPDIR}mongodb-tools.zip ..."
		unzip "${TMPDIR}mongodb-tools.zip" -d "$TMPDIR" >/dev/null

		echo "-> Installing in $HOME/.local/bin/ ..."
		rm -rf "$HOME/.local/bin"/mongo{dump,export,files,import,restore,stat,top}
		mv "${TMPDIR}mongodb-database-tools-macos-${arch}-${mongo_tools_version}/bin/mongo"* "$HOME/.local/bin/"

		echo "-> Finished."

	elif [ "$system" = "Linux" ]; then
		# TODO
		:
	fi
fi

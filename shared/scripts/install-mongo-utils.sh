# vim:ft=bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"

set -e
trap_exit () {
	rm -rf "$TMPDIR"/mongodb*
	rm -rf "$TMPDIR"/mongosh*
}
source "$this_script_rel_path/helper.sh"
trap trap_error ERR
trap trap_exit EXIT

arch="$(uname -m)"
system="$(uname -s)"
mongo_sh_version="2.3.0"
mongo_tools_version="100.10.0"

if [ "$1" == "shell" ]; then
	rm -rf "$TMPDIR"/mongosh*

	# This could just be a simple `brew install mongosh` but it has an uncessary
	# dependecy on Node.js/NPM.
	if [ "$system" = "Darwin" ]; then

		[ "$arch" = "x86_64" ] && arch="x64" || true
		url="https://downloads.mongodb.com/compass/mongosh-${mongo_sh_version}-darwin-${arch}.zip"

		echo "-> Downloading $url ..."
		curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
			--progress-bar -L -S "$url" -o "$TMPDIR"mongosh.zip

		echo "-> Extracting "$TMPDIR"mongosh.zip ..."
		unzip "$TMPDIR"/mongosh.zip -d "$TMPDIR" >/dev/null

		echo "-> Installing in "$HOME"/.local/bin/ ..."
		rm -rf "$HOME"/.local/bin/mongosh
		mv "$TMPDIR"/"mongosh-${mongo_sh_version}-darwin-${arch}"/bin/mongosh \
			"$HOME"/.local/bin/

		echo "-> Finished."

	elif [ "$system" = "Linux" ]; then
		# TODO
		:
	fi

elif [ "$1" == "tools" ]; then
	rm -rf "$TMPDIR"/mongodb*

	if [ "$system" = "Darwin" ]; then
		url="https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-${arch}-${mongo_tools_version}.zip"
		echo "-> Downloading $url ..."
		curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
			--progress-bar -L -S "$url" -o "$TMPDIR"mongodb-tools.zip

		echo "-> Extracting "$TMPDIR"mongodb-tools.zip ..."
		unzip "$TMPDIR"/mongodb-tools.zip -d "$TMPDIR" >/dev/null

		echo "-> Installing in "$HOME"/.local/bin/ ..."
		rm -rf "$HOME"/.local/bin/mongo{dump,export,import,restore,stat,top}
		mv "$TMPDIR"/"mongodb-database-tools-macos-${arch}-${mongo_tools_version}"/bin/mongo* \
			"$HOME"/.local/bin/

		echo "-> Finished."

	elif [ "$system" = "Linux" ]; then
		# TODO
		:
	fi
fi

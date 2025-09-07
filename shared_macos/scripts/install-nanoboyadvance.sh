#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR
# shellcheck disable=SC2155

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"

source "$rootdir/shared/scripts/helper.sh"
trap trap_error ERR

trap_exit () {
	rm -rf "${TMPDIR}${app_name}"
}
trap trap_exit EXIT

app_name="NanoBoyAdvance"
download_dir="${TMPDIR}${app_name}"
install_dir="/Applications"
uninstall="false"
version=""
while [[ $# -gt 0 ]]; do case $1 in
	--uninstall)
		uninstall="true";
		shift;;
	--version)
		version="$2";
		shift; shift;;
	*)
		shift;;
esac; done

	if [ "$uninstall" = "true" ]; then
		echo "-> Uninstalling $app_name ..."
		rm -rf /Applications/${app_name}.app
		rm -rf "$HOME/Library/Application Support/org.github.fleroviux.${app_name}"
		echo "-> Finished."
		exit 0
	fi

	if [ -z "$version" ]; then
		echo "-> Querying ${app_name}'s latest available version ..."
		version=$(
			curl --connect-timeout 13 --fail --location --retry 5 --retry-delay 2 \
				--show-error --silent \
				--header "Accept:application/vnd.github.v3.raw" \
				"https://api.github.com/repos/nba-emu/${app_name}/releases/latest" |
			jq --raw-output '.name'
		)
		version=${version#* }
	fi

	_arch="$(uname -m)"
	if [ "$_arch" = "arm64" ]; then
		arch="ARM64"
	elif [ "$_arch" = "x86_64 " ]; then
		arch="intel"
	fi
	url="https://github.com/nba-emu/${app_name}/releases/download/v${version}/${app_name}-${version}-macOS-${arch}.zip"
	echo "-> Downloading $url ..."
	mkdir -p "$download_dir"
	curl --connect-timeout 13 --fail --location --progress-bar \
		--retry 5 --retry-delay 2 --show-error \
		--output "$download_dir/${app_name}.zip" \
		"$url"

	echo "-> Extracting ${download_dir}/${app_name}.zip ..."
	unzip  "${download_dir}/${app_name}.zip" -d "$download_dir" &>/dev/null

	echo "-> Installing in $install_dir ..."
	hdiutil attach "${download_dir}/${app_name}.dmg" &>/dev/null
	rm -rf "${install_dir}/${app_name}.app"
	cp -R "/Volumes/${app_name}/${app_name}.app" "$install_dir/"
	umount "/Volumes/${app_name}"

	echo "-> Finished."

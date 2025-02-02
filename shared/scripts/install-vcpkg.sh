#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"

source "$rootdir/shared/scripts/helper.sh"
trap 'rm -rf "$TMPDIR/vcpkg"; [[ ${#DIRSTACK[@]} -gt 1 ]] && popd >/dev/null; trap_error' ERR
trap 'rm -rf "$TMPDIR/vcpkg"' EXIT

tag="2025.01.13"
url="https://github.com/microsoft/vcpkg.git"

clean_install () {
	echo "-> Cloning vcpkg ..."
	git clone -q --branch "$tag" "$url" "$TMPDIR/vcpkg"

	echo "-> Bootstrapping vcpkg ..."
	cd "$TMPDIR/vcpkg" && ./bootstrap-vcpkg.sh && cd -

	echo "-> Installing vcpkg ..."
	[ -d "$VCPKG_ROOT" ] && rm -rf "$VCPKG_ROOT"
	mv "$TMPDIR/vcpkg" "$VCPKG_ROOT"
	ln -sf "$VCPKG_ROOT/vcpkg" ~/.local/bin/vcpkg

	echo "-> Done!"
}

update_preexisting () {
	echo "-> Updating preexisting setup ..."
	pushd "$VCPKG_ROOT" >/dev/null
	git checkout master
	git pull --prune
	git checkout "$tag"

	echo "-> Bootstrapping and installing vcpkg ..."
	./bootstrap-vcpkg.sh
	ln -sf "$VCPKG_ROOT/vcpkg" ~/.local/bin/vcpkg

	popd >/dev/null
	echo "-> Done!"
}

if [ -d "$VCPKG_ROOT" ]; then
	update_preexisting
else
	clean_install
fi

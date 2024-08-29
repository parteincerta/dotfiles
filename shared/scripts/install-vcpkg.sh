#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"

source "$rootdir/shared/scripts/helper.sh"
trap 'rm -rf "$TMPDIR/vcpkg"; trap_error' ERR

tag="2024.08.23"
url="https://github.com/microsoft/vcpkg.git"

echo "-> Cloning vcpkg ..."
git clone -q --depth 1 --branch "$tag" "$url" "$TMPDIR/vcpkg"

echo "-> Bootstraping vcpkg ..."
cd "$TMPDIR/vcpkg" && ./bootstrap-vcpkg.sh

echo "-> Installing vcpkg ..."
[ -d "$VCPKG_ROOT" ] && rm -rf "$VCPKG_ROOT"
mv "$TMPDIR/vcpkg" "$VCPKG_ROOT"

echo "-> Done!"

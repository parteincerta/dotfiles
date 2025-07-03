#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -e

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"
pushd "$scriptdir" >/dev/null
trap "popd >/dev/null" EXIT

source "$rootdir/shared/scripts/helper.sh"
trap "popd >/dev/null; trap_error" ERR

cp "$rootdir/shared_macos/.bash_profile" "$HOME/"
sed -i '' "s|#EXTERNAL_VOLUME||" "$HOME/.bash_profile"
ln -sf "$HOME/.bash_profile" "$HOME/.bashrc"
# shellcheck disable=SC1091
source "$HOME/.bash_profile" || true

expected_hostname="mba15-m4"
if [ "$expected_hostname" != "$SHORT_HOSTNAME" ]; then
	log_warning ">>> This configuration script belongs to another host: $expected_hostname".
	log_warning ">>> The current host is: $SHORT_HOSTNAME"
	exit 1
fi

mkdir -p \
"$HOME"/{.gnupg,.local/{bin,share/lf},.ssh/sockets} \
"$HOME"/.local/{bin,share/lf} \
"$HOME"/Library/{KeyBindings,LaunchAgents} \
"$HOME/Library/Application Support/com.nuebling.mac-mouse-fix/" \
"$XDG_CONFIG_HOME"/{bat/themes,fd,git,lf,nvim,pip} \
"$CODE/github" \
"$DOCUMENTS"/{Captures,Misc} \
"$DOWNLOADS"/{Chrome,Other,Safari}

app_support_folder="$HOME/Library/Application Support"

cp "$rootdir/shared/.inputrc" "$HOME/"
cp "$rootdir/shared/git.conf" "$XDG_CONFIG_HOME/git/config"
cp "$rootdir/shared/gpg.conf" "$HOME/.gnupg/"
cp "$rootdir/shared/fdignore" "$XDG_CONFIG_HOME/fd/ignore"
cp "$rootdir/shared/lficons" "$XDG_CONFIG_HOME/lf/icons"
cp "$rootdir/shared/lfpreview" "$HOME/.local/bin/"
cp "$rootdir/shared/pip.conf" "$XDG_CONFIG_HOME/pip/"
cp "$rootdir/shared/ssh.conf" "$HOME/.ssh/config"
cp "$rootdir/shared/tokyonight-moon.tmTheme" "$XDG_CONFIG_HOME/bat/themes"
cp "$rootdir/shared_macos/lfrc" "$XDG_CONFIG_HOME/lf/"

[ ! -f "/Library/Managed Preferences/com.google.keystone.plist" ] &&
	echo "Disabling Google's Auto Updater requires elevated privileges ..." &&
	sudo mkdir -p "/Library/Managed Preferences" &&
	sudo cp "$rootdir/shared_macos/plist/com.google.Keystone.plist" "/Library/Managed Preferences/"

chmod u=rwx,g=,o= "$HOME/.gnupg"
chmod u=rw,g=,o= "$HOME/.gnupg/"*
chmod u=rwx,g=,o= "$HOME/.ssh"
chmod u=rwx,g=,o= "$HOME/.ssh/sockets"
chmod u+x "$HOME/.local/bin/lfpreview"

touch "$HOME/.bash_sessions_disable"
touch "$HOME/.hushlogin"
touch "$XDG_CONFIG_HOME/lf/bookmarks"

source "$rootdir/shared_macos/scripts/export-defaults.sh" --source-keys-only
defaults import "$actmon_key" "$actmon_file"
defaults import "$alttab_key" "$alttab_file"
defaults import "$betterdisplay_key" "$betterdisplay_file"
cp "$macmousefix_file" "$app_support_folder/com.nuebling.mac-mouse-fix/config.plist"

# This section is reserved for files that must be patched upfront.
# ================================================================

if [ -n "$HOMEBREW_PREFIX" ]; then
	envsubst <"$rootdir/shared_macos/lfmarks" >"$HOME/.local/share/lf/marks"
fi

# vim:ft=bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"
this_script_abs_path="$(cd $this_script_rel_path >/dev/null && pwd)"
shared_dir="$(cd $this_script_abs_path/../../shared >/dev/null && pwd)"

set -e
source "$shared_dir/scripts/helper.sh"
trap trap_error ERR

force_disable_brave () {
	[ ! -d "/Applications/Brave Browser.app" ] && return 0

	echo ">>> Disabling Brave's automatic updates ..."

	local aupath=$(join_strings \
		"/Applications/Brave Browser.app/Contents/Frameworks/"\
		"Brave Browser Framework.framework/Versions/Current/"\
		"/Frameworks/Sparkle.framework/Versions/A/Resources"
	)
	$(
		if [ -d "$aupath/Autoupdate.app" ]; then
			mv "$aupath/Autoupdate.app" "$aupath/DisableAutoupdate.app"
		fi
	)
}

force_disable_chrome () {
	[ ! -d "$HOME"/Library/Google/GoogleSoftwareUpdate ] && return 0

	echo ">>> Disabling Google Chrome's automatic updates ..."
	sudo chown nobody:nobody "$HOME"/Library/Google/GoogleSoftwareUpdate
	sudo chmod 000 "$HOME"/Library/Google/GoogleSoftwareUpdate
}

force_disable_brave
force_disable_chrome
echo ">>> Done!"
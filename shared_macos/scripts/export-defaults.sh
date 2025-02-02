#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"

source "$rootdir/shared/scripts/helper.sh"
trap trap_error ERR

nice_hostname="${HOSTNAME/%.local/}"
hostdir="$rootdir/macos/$nice_hostname"

# Activity Monitor
actmon_key="com.apple.ActivityMonitor"
actmon_file="$hostdir/plist/${actmon_key}.plist"

# AltTab
alttab_key="com.lwouis.alt-tab-macos"
alttab_file="$rootdir/shared_macos/plist/${alttab_key}.plist"

# BetterDisplay
betterdisplay_key="pro.betterdisplay.BetterDisplay"
betterdisplay_file="$hostdir/plist/${betterdisplay_key}.plist"

# Mac Mouse Fix
macmousefix_key="com.nuebling.mac-mouse-fix"
macmousefix_file="$rootdir/shared_macos/plist/${macmousefix_key}.plist"

# OBS
obsdir="$HOME/Library/Application Support/obs-studio/basic"

# Rectangle
# rectangle_key="com.knollsoft.Rectangle"
# rectangle_file="$rootdir/shared_macos/plist/${rectangle_key}.plist"
# rectangle_chords_key="com.knollsoft.Hookshot"
# rectangle_chords_file="$rootdir/shared_macos/plist/${rectangle_chords_key}.plist"

if [ "$1" = "--source-keys-only" ]; then
	return 0
fi

log_info ">>> Exporting Activity Monitor settings..."
defaults export "$actmon_key" "$actmon_file"

log_info ">>> Exporting AltTab settings..."
defaults export "$alttab_key" "$alttab_file"

log_info ">>> Exporting Betterdisplay settings..."
defaults export "$betterdisplay_key" "$betterdisplay_file"

log_info ">>> Exporting Mac Mouse Fix settings..."
cp "$HOME/Library/Application Support/${macmousefix_key}/config.plist" "$macmousefix_file"

if [ -d  "$obsdir" ]; then
	log_info ">>> Exporting OBS settings..."
	rm -rf "$hostdir/obs"
	cp -R "$obsdir" "$hostdir/obs"
	find "$hostdir/obs" -name "*.bak" -type f -delete
fi

# log_info ">>> Exporting Rectangle settings..."
# defaults export "$rectangle_key" "$rectangle_file"

# log_info ">>> Exporting Rectangle chord settings..."
# defaults export "$rectangle_chords_key" "$rectangle_chords_file"

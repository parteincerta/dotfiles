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
sed -i '' "s|#EXTERNAL_VOLUME|/Volumes/A4|" "$HOME/.bash_profile"
ln -sf "$HOME/.bash_profile" "$HOME/.bashrc"
# shellcheck disable=SC1091
source "$HOME/.bash_profile" || true

expected_hostname="ms-m1u"
if [ "$expected_hostname" != "$SHORT_HOSTNAME" ]; then
	log_warning ">>> This configuration script belongs to another host: $expected_hostname".
	log_warning ">>> The current host is: $SHORT_HOSTNAME"
	exit 1
fi

mkdir -p \
"$HOME"/{.gnupg,.local/{bin,share/lf},.m2,.ssh/sockets} \
"$HOME"/.local/{bin,share/lf} \
"$HOME"/Library/{KeyBindings,LaunchAgents} \
"$HOME/Library/Application Support/Code/User/" \
"$HOME/Library/Application Support/com.nuebling.mac-mouse-fix/" \
"$HOME/Library/Application Support/obs-studio/basic/" \
"$XDG_CACHE_HOME/code"/{data/User,extensions} \
"$XDG_CACHE_HOME/bun"/{bin,cache-install,cache-transpiler,lib} \
"$XDG_CACHE_HOME/deno/cache" \
"$XDG_CONFIG_HOME"/{bat/themes,fd,gradle,fish/completions,ghostty,git,kitty,lf,mise,nvim,pip,zed} \
"$DOWNLOADS"/{Brave,Safari}

if [ -d "$EXTERNAL_VOLUME" ]; then
	mkdir -p \
		"$EXTERNAL_VOLUME"/Developer/{github,parteincerta} \
		"$EXTERNAL_VOLUME"/Developer/icnew/{git-icone,git-icone-dog,misc} \
		"$EXTERNAL_VOLUME"/{Docker,Captures,Misc,Other,Remote,Torrents,VMs}

	ln -fs "$EXTERNAL_VOLUME/Developer/github" "$CODE"
	ln -fs "$EXTERNAL_VOLUME/Developer/icnew" "$CODE"
	ln -fs "$EXTERNAL_VOLUME/Developer/parteincerta" "$CODE"

	ln -fs "$EXTERNAL_VOLUME/Captures" "$DOCUMENTS"
	ln -fs "$EXTERNAL_VOLUME/Misc" "$DOCUMENTS"
	ln -fs "$EXTERNAL_VOLUME/Remote" "$DOCUMENTS"
	ln -fs "$EXTERNAL_VOLUME/VMs" "$DOCUMENTS"

	ln -fs "$EXTERNAL_VOLUME/Other" "$DOWNLOADS"
	ln -fs "$EXTERNAL_VOLUME/Torrents" "$DOWNLOADS"
fi

app_support_folder="$HOME/Library/Application Support"
vscode_cache_dir="$XDG_CACHE_HOME/code/data/User"
vscode_settings_dir="$app_support_folder/Code/User"

rm -rf "$XDG_CONFIG_HOME/nvim/"{init.lua,lua/}
cp "$rootdir/shared/.inputrc" "$HOME/"
cp "$rootdir/shared/git.conf" "$XDG_CONFIG_HOME/git/config"
cp "$rootdir/shared/gpg.conf" "$HOME/.gnupg/"
cp "$rootdir/shared/fdignore" "$XDG_CONFIG_HOME/fd/ignore"
cp "$rootdir/shared/keybindings.vscode.json" "$vscode_cache_dir/keybindings.json"
cp "$rootdir/shared/keybindings.vscode.json" "$vscode_settings_dir/keybindings.json"
cp "$rootdir/shared/kitty_theme.conf" "$XDG_CONFIG_HOME/kitty/"
cp "$rootdir/shared/lficons" "$XDG_CONFIG_HOME/lf/icons"
cp "$rootdir/shared/lfpreview" "$HOME/.local/bin/"
cp -R "$rootdir/shared/neovim/"* "$XDG_CONFIG_HOME/nvim/"
cp "$rootdir/shared/obs-mask.png" "$DOCUMENTS/Misc/"
cp "$rootdir/shared/pip.conf" "$XDG_CONFIG_HOME/pip/"
cp "$rootdir/shared/ssh.conf" "$HOME/.ssh/config"
cp "$rootdir/shared/tokyonight-moon.tmTheme" "$XDG_CONFIG_HOME/bat/themes"
cp "$rootdir/shared/zed.keymap.json" "$XDG_CONFIG_HOME/zed/keymap.json"
cp "$rootdir/shared_macos/config.fish" "$XDG_CONFIG_HOME/fish/"
cp "$rootdir/shared_macos/lfrc" "$XDG_CONFIG_HOME/lf/"
cp other/mise.toml "$XDG_CONFIG_HOME/mise/config.toml"

# rm -rf "$app_support_folder/obs-studio/basic/"* &&
# 	cp -R obs/* "$app_support_folder/obs-studio/basic"

chmod u=rwx,g=,o= "$HOME/.gnupg"
chmod u=rw,g=,o= "$HOME/.gnupg/"*
chmod u=rwx,g=,o= "$HOME/.ssh"
chmod u=rwx,g=,o= "$HOME/.ssh/sockets"
chmod u+x "$HOME/.local/bin/lfpreview"
sed -i '' "s|#EXTERNAL_VOLUME|/Volumes/A4|" "$XDG_CONFIG_HOME/fish/config.fish"

touch "$HOME/.bash_sessions_disable"
touch "$HOME/.hushlogin"
touch "$XDG_CONFIG_HOME/lf/bookmarks"

source "$rootdir/shared_macos/scripts/export-defaults.sh" --source-keys-only
# defaults import "$actmon_key" "$actmon_file"
defaults import "$alttab_key" "$alttab_file"
# defaults import "$betterdisplay_key" "$betterdisplay_file"
cp "$macmousefix_file" "$app_support_folder/com.nuebling.mac-mouse-fix/config.plist"

# This section is reserved for files that must be patched upfront.
# ================================================================

if [ -n "$HOMEBREW_PREFIX" ]; then
	export bun_cache_dir="$XDG_CACHE_HOME/bun/cache-install"
	export bun_global_bindir="$XDG_CACHE_HOME/bun/bin"
	export bun_global_dir="$XDG_CACHE_HOME/bun/lib"
	export font_size="10.5"
	export kitty_enable_cursor_trail="1"
	export kitty_qat_margin_left="200"
	export kitty_qat_margin_right="200"
	export terminal_window_height="35"
	export terminal_window_width="160"

	envsubst <"$rootdir/shared_macos/.bunfig.toml" >"$XDG_CONFIG_HOME/.bunfig.toml"
	envsubst <"$rootdir/shared_macos/ghostty.conf" >"$XDG_CONFIG_HOME/ghostty/config"
	envsubst <"$rootdir/shared_macos/kitty.conf" >"$XDG_CONFIG_HOME/kitty/kitty.conf"
	envsubst <"$rootdir/shared_macos/lfmarks" >"$HOME/.local/share/lf/marks"
	envsubst <"$rootdir/shared_macos/quick-access-terminal.conf" >"$XDG_CONFIG_HOME/kitty/quick-access-terminal.conf"
	envsubst <"$rootdir/shared/settings.vscode.json" >"$TMPDIR/settings.vscode.json"
	envsubst <"$rootdir/shared/zed.settings.json" >"$XDG_CONFIG_HOME/zed/settings.json"
	cp "$TMPDIR/settings.vscode.json" "$vscode_cache_dir/settings.json"
	cp "$TMPDIR/settings.vscode.json" "$vscode_settings_dir/settings.json"
	rm "$TMPDIR/settings.vscode.json"
fi

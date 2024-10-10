#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -e
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"
pushd "$scriptdir" >/dev/null
trap "popd >/dev/null" EXIT

source "$rootdir/shared/scripts/helper.sh"
trap "popd >/dev/null; trap_error" ERR


nice_hostname="${HOSTNAME/%.local/}"
if [ "egas" != "$nice_hostname" ]; then
	log_warning ">>> This configuration script belongs to another host: egas".
	log_warning ">>> The current host is: $nice_hostname"
	exit 1
fi

source "$rootdir/shared_macos/.bash_profile" || true

mkdir -p \
"$HOME"/{.gnupg,.local/{bin,share/lf},.m2,.ssh/sockets} \
"$HOME"/.local/{bin,share/lf} \
"$HOME"/Library/{KeyBindings,LaunchAgents} \
"$HOME/Library/Application Support/Code/User/" \
"$HOME/Library/Application Support/com.nuebling.mac-mouse-fix/" \
"$HOME/Library/Application Support/obs-studio/basic/" \
"$XDG_CACHE_HOME"/{ads,code}/{data/User,extensions} \
"$XDG_CACHE_HOME/bun"/{bin,cache/{install,transpiler},lib} \
"$XDG_CONFIG_HOME"/{bat/themes,fd,gradle,fish,git,kitty,lf,mise,nvim,pip,zed} \
"$CODE"/{github,icnew/{git-icone,misc},parteincerta} \
"$DOCUMENTS"/{Misc,Recordings,Remote,Screenshots,VMs} \
"$DOWNLOADS"/{Brave,Safari,Torrents}

if [ -d "$EXTERNAL_VOLUME" ]; then
	mkdir -p "$EXTERNAL_VOLUME/"{Misc,VMs}
fi

app_support_folder="$HOME/Library/Application Support"
vscode_cache_dir="$XDG_CACHE_HOME/code/data/User"
vscode_settings_dir="$app_support_folder/Code/User"

rm -rf "$XDG_CONFIG_HOME/nvim/"{init.lua,lua/}

cp mise.toml "$XDG_CONFIG_HOME/mise/config.toml"
cp -R obs/* "$app_support_folder/obs-studio/basic"

cp "$rootdir/shared_macos/.bash_profile" "$HOME/"
cp "$rootdir/shared_macos/config.fish" "$XDG_CONFIG_HOME/fish/"
cp "$rootdir/shared_macos/lfrc" "$XDG_CONFIG_HOME/lf/"

cp "$rootdir/shared/.inputrc" "$HOME/"
cp "$rootdir/shared/git.conf" "$XDG_CONFIG_HOME/git/config"
cp "$rootdir/shared/gpg.conf" "$HOME/.gnupg/"
cp "$rootdir/shared/fdignore" "$XDG_CONFIG_HOME/fd/ignore"
cp "$rootdir/shared/keybindings.vscode.json" "$vscode_cache_dir/keybindings.json"
cp "$rootdir/shared/keybindings.vscode.json" "$vscode_settings_dir/keybindings.json"
cp "$rootdir/shared/lficons" "$XDG_CONFIG_HOME/lf/icons"
cp "$rootdir/shared/lfpreview" "$HOME/.local/bin/"
cp -R "$rootdir/shared/neovim/"* "$XDG_CONFIG_HOME/nvim/"
cp "$rootdir/shared/obs-mask.png" "$DOCUMENTS/Misc/"
cp "$rootdir/shared/pip.conf" "$XDG_CONFIG_HOME/pip/"
cp "$rootdir/shared/ssh.conf" "$HOME/.ssh/config"
cp "$rootdir/shared/tokyonight-moon.tmTheme" "$XDG_CONFIG_HOME/bat/themes"
cp "$rootdir/shared/zed.keymaps.json" "$XDG_CONFIG_HOME/zed/keymaps.json"

ln -sf "$HOME/.bash_profile" "$HOME/.bashrc"
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

# NOTE: The following are configuration files that
# must be patched before being put in their place.

cp "$rootdir/shared_macos/.bunfig.toml" "$TMPDIR/"
sed -i '' "s|#bun.install.globalDir|$XDG_CACHE_HOME/bun/lib|" "$TMPDIR/.bunfig.toml"
sed -i '' "s|#bun.install.globalBinDir|$XDG_CACHE_HOME/bun/bin|" "$TMPDIR/.bunfig.toml"
sed -i '' "s|#bun.install.cache.dir|$XDG_CACHE_HOME/bun/cache/install|" "$TMPDIR/.bunfig.toml"
mv "$TMPDIR/.bunfig.toml" "$XDG_CONFIG_HOME/"

font_size="10.5"

cp "$rootdir/shared/settings.vscode.json" "$TMPDIR/"
sed -i '' "/\"editor.fontSize\"/s/0/$font_size/" "$TMPDIR/settings.vscode.json"
cp "$TMPDIR/settings.vscode.json" "$vscode_cache_dir/settings.json"
cp "$TMPDIR/settings.vscode.json" "$vscode_settings_dir/settings.json"

cp "$rootdir/shared/zed.settings.json" "$TMPDIR/"
sed -i '' "/\"buffer_font_size\"/s/0/$font_size/" "$TMPDIR/zed.settings.json"
sed -i '' "/\"font_size\"/s/0/$font_size/" "$TMPDIR/zed.settings.json"
mv "$TMPDIR/zed.settings.json" "$XDG_CONFIG_HOME/zed/settings.json"

(echo "cat <<EOF"; cat "$rootdir/shared_macos/lfmarks"; echo EOF) |
	sh >"$HOME/.local/share/lf/marks"

# NOTE: The following can only be patched once Homebrew is installed.
if [ -n "$HOMEBREW_PREFIX" ]; then
	cp "$rootdir/shared_macos/kitty.conf" "$TMPDIR/"
	sed -i '' "s|%font_size|$font_size|g" "$TMPDIR/kitty.conf"
	sed -i '' "s|%homebrew_path|$HOMEBREW_PREFIX|g" "$TMPDIR/kitty.conf"
	mv "$TMPDIR/kitty.conf" "$XDG_CONFIG_HOME/kitty/kitty.conf"
	cp "$rootdir/shared/kitty_theme.conf" "$XDG_CONFIG_HOME/kitty/"
fi

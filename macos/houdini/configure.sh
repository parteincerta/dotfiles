#!/bin/bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"
this_script_abs_path="$(cd $this_script_rel_path >/dev/null && pwd)"
shared_dir="$(cd $this_script_abs_path/../../shared >/dev/null && pwd)"
shared_dir_macos="$(cd $this_script_abs_path/../../shared_macos >/dev/null && pwd)"

set -e
source "$shared_dir/scripts/helper.sh"
trap trap_error ERR
pushd "$this_script_abs_path" >/dev/null
trap "popd >/dev/null" EXIT


if [ "houdini" != "$system_hostname" ]; then
	log_warning ">>> This configuration script belongs to another host: houdini".
	log_warning ">>> The current host is: $system_hostname"
	exit 1
fi

source "$shared_dir_macos/.bash_profile" || true

mkdir -p \
"$HOME"/{.gnupg,.m2,.local/{bin,share/lf},.ssh/sockets} \
"$HOME"/.local/{bin,share/lf} \
"$HOME"/Library/{KeyBindings,LaunchAgents} \
"$HOME/Library/Application Support/Code/User/" \
"$HOME/Library/Application Support/com.nuebling.mac-mouse-fix/" \
"$HOME/Library/Application Support/obs-studio/basic/" \
"$XDG_CACHE_HOME"/{ads,code}/{data/User,extensions} \
"$XDG_CACHE_HOME/bun"/{bin,cache/{install,transpiler},lib} \
"$XDG_CONFIG_HOME"/{bat/themes,fd,fish,git,kitty,lf,mise,nvim,pip,zed} \
"$CODE"/{github,icnew/{git-icone,misc},parteincerta} \
"$DOCUMENTS"/{Misc,Recordings,Remote,Screenshots} \
"$DOWNLOADS"/{Brave,Safari,Torrents}

app_support_folder="$HOME/Library/Application Support"
vscode_cache_dir="$XDG_CACHE_HOME/code/data/User"
vscode_settings_dir="$app_support_folder/Code/User"

rm -rf "$XDG_CONFIG_HOME/nvim/"{init.lua,lua/}

cp maven.toolchains.xml "$HOME/.m2/toolchains.xml"
cp mise.toml "$XDG_CONFIG_HOME/mise/config.toml"
cp -R obs/* "$app_support_folder/obs-studio/basic"

cp "$shared_dir_macos/.bash_profile" "$HOME/"
cp "$shared_dir_macos/config.fish" "$XDG_CONFIG_HOME/fish/"
cp "$shared_dir_macos/lfrc" "$XDG_CONFIG_HOME/lf/"

cp "$shared_dir/.inputrc" "$HOME/"
cp "$shared_dir/git.conf" "$XDG_CONFIG_HOME/git/config"
cp "$shared_dir/gpg.conf" "$HOME/.gnupg/"
cp "$shared_dir/fdignore" "$XDG_CONFIG_HOME/fd/ignore"
cp "$shared_dir/keybindings.vscode.json" "$vscode_cache_dir/keybindings.json"
cp "$shared_dir/keybindings.vscode.json" "$vscode_settings_dir/keybindings.json"
cp "$shared_dir/lficons" "$XDG_CONFIG_HOME/lf/icons"
cp "$shared_dir/lfpreview" "$HOME/.local/bin/"
cp -R "$shared_dir/neovim/"* "$XDG_CONFIG_HOME/nvim/"
cp "$shared_dir/pip.conf" "$XDG_CONFIG_HOME/pip/"
cp "$shared_dir/ssh.conf" "$HOME/.ssh/config"
cp "$shared_dir/tokyonight-moon.tmTheme" "$XDG_CONFIG_HOME/bat/themes"
cp "$shared_dir/zed.keymaps.json" "$XDG_CONFIG_HOME/zed/keymaps.json"

ln -sf "$HOME/.bash_profile" "$HOME/.bashrc"
chmod u=rwx,g=,o= "$HOME/.gnupg"
chmod u=rw,g=,o= "$HOME/.gnupg/"*
chmod u=rwx,g=,o= "$HOME/.ssh"
chmod u=rwx,g=,o= "$HOME/.ssh/sockets"
chmod u+x "$HOME/.local/bin/lfpreview"

touch "$HOME/.bash_sessions_disable"
touch "$HOME/.hushlogin"
touch "$XDG_CONFIG_HOME/lf/bookmarks"

source "$shared_dir_macos/scripts/export-defaults.sh" --source-keys-only
defaults import "$actmon_key" "$actmon_file"
defaults import "$alttab_key" "$alttab_file"
defaults import "$betterdisplay_key" "$betterdisplay_file"
# defaults import "$rectangle_key" "$rectangle_file"
# defaults import "$rectangle_chords_key" "$rectangle_chords_file"
cp "$macmousefix_file" "$app_support_folder/com.nuebling.mac-mouse-fix/config.plist"

# NOTE: The following are configuration files that
# bust be patched before being put in their place.

cp "$shared_dir_macos/.bunfig.toml" "$TMPDIR/"
sed -i '' "s|#bun.install.globalDir|$XDG_CACHE_HOME/bun/lib|" "$TMPDIR/.bunfig.toml"
sed -i '' "s|#bun.install.globalBinDir|$XDG_CACHE_HOME/bun/bin|" "$TMPDIR/.bunfig.toml"
sed -i '' "s|#bun.install.cache.dir|$XDG_CACHE_HOME/bun/cache/install|" "$TMPDIR/.bunfig.toml"
mv "$TMPDIR/.bunfig.toml" "$XDG_CONFIG_HOME/"

font_size="10.5"

cp "$shared_dir/settings.vscode.json" "$TMPDIR/"
sed -i '' "/\"editor.fontSize\"/s/0/$font_size/" "$TMPDIR/settings.vscode.json"
cp "$TMPDIR/settings.vscode.json" "$vscode_cache_dir/settings.json"
cp "$TMPDIR/settings.vscode.json" "$vscode_settings_dir/settings.json"

cp "$shared_dir/zed.settings.json" "$TMPDIR/"
sed -i '' "/\"buffer_font_size\"/s/0/$font_size/" "$TMPDIR/zed.settings.json"
sed -i '' "/\"font_size\"/s/0/$font_size/" "$TMPDIR/zed.settings.json"
mv "$TMPDIR/zed.settings.json" "$XDG_CONFIG_HOME/zed/settings.json"

(echo "cat <<EOF"; cat "$shared_dir_macos/lfmarks"; echo EOF) |
	sh >"$HOME/.local/share/lf/marks"

# NOTE: The following can only be patched once Homebrew is installed.
if [ -n "$HOMEBREW_PREFIX" ]; then
	cp "$shared_dir_macos/kitty.conf" "$TMPDIR/"
	sed -i '' "s|%font_size|$font_size|g" "$TMPDIR/kitty.conf"
	sed -i '' "s|%homebrew_path|$HOMEBREW_PREFIX|g" "$TMPDIR/kitty.conf"
	mv "$TMPDIR/kitty.conf" "$XDG_CONFIG_HOME/kitty/kitty.conf"
	cp "$shared_dir/kitty_theme.conf" "$XDG_CONFIG_HOME/kitty/"
fi

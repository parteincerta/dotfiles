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


xcode_cli_tools_path="$(xcode-select --print-path 2>/dev/null || true)"
if [ -d "$xcode_cli_tools_path" ]; then
	log_info "\t >>> XCode CLI Tools available at: $xcode_cli_tools_path"
else
	log_error "\t >>> XCode CLI Tools not available."
	log_error "\t >>> To install them: \$ xcode-select --install"
	exit 1
fi


bootstrap_mark_file="$HOME/.bootstrapped"
if [ -s "$bootstrap_mark_file" ]; then
	log_warning ">>> This system was previously bootstrapped."
	exit 1
	log_warning ">>> To restart the process: \$ rm $bootstrap_mark_file"
fi

if [ "houdini" != "$system_hostname" ]; then
	log_warning ">>> This bootstrap script belongs to another host: houdini".
	log_warning ">>> The current host is: $system_hostname"
	exit 1
fi

log_info "\t >>> Installing dotfiles"
source configure.sh


log_info "\t >>> Configuring the Desktop and keyboard"
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.30
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.Safari DebugDisableTabHoverPreview 1
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write -g NSWindowShouldDragOnGesture -bool true
killall Dock


if [ -z "$(command -v brew)" ]; then
	log_info "\t >>> Installing Homebrew"
	homebrew_url="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
	/bin/bash -c "$(curl --fail --location --silent --show-error $homebrew_url)"
	source "$shared_dir_macos/.bash_profile" || true
fi


log_info "\t >>> Installing Homebrew apps"
# NOTE: `gettext` is installed to have `envsubst`
fonts=(font-jetbrains-mono-nerd-font)
homebrew_cli=(
	7zip aria2 bat bash bash-completion@2 bzip2 coreutils eza fd findutils fish
	${fonts[*]} fzf gettext git-delta gnupg gsed jq lf libpq miniserve mise
	mkcert moreutils neovim oha pbzip2 pigz rclone ripgrep tokei xz zstd
)
brew install ${homebrew_cli[*]}

# `jdtls` has many dependencies, among them: `openjdk` and `python@3.12`.
# JDK will be handled by `mise``. `python@3.12` will be installed next.
# Hence the usage of --ignore-dependencies.
brew install --ignore-dependencies jdtls maven

# Java's LSP needs Homebrew's Python (see `brew info jdtls`) but we don't so
# lets unlink it after installation. Also unlink openssl@3 in favor of Apple's
# OpenSSL.
brew install python@3.12
brew unlink python@3.12 openssl@3


log_info "\t >>> Installing Homebrew casks"
compass="mongodb-compass-isolated-edition"
dbeaver="dbeaver-community"
microsoft_apps=(microsoft-{excel,powerpoint,remote-desktop,word})
vscode="visual-studio-code"
homebrew_casks=(
	alt-tab basictex betterdisplay brave-browser bruno $compass $dbeaver docker
	fork iina kitty mac-mouse-fix ${microsoft_apps[*]} numi obs transmission
	$vscode zed zoom
)
brew install --cask ${homebrew_casks[*]}


log_info "\t >>> Sourcing environment variables and re-installing dotfiles"
source "$shared_dir_macos/.bash_profile" || true
source configure.sh
bat cache --build


log_info "\t >>> Setting up the hosts file"
source "$shared_dir/scripts/install-hosts.sh" houdini


log_info "\t >>> Installing pip packages"
pip3 install --user wheel
pip3 install --user pynvim


log_info "\t >>> Installing mise packages"
MISE_YES=1 mise install
sudo mkdir /Library/Java/JavaVirtualMachines/temurin-21.jdk
sudo ln -s "$HOME/.local/share/mise/installs/java/temurin-21" \
	/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents


log_info "\t >>> Installing MongoDB Shell and Tools"
source "$shared_dir/scripts/install-mongo-utils.sh" shell
source "$shared_dir/scripts/install-mongo-utils.sh" tools


log_info "\t >>> Installing Neovim plugins"
nvim --headless -c "Lazy! install" -c qall


log_info "\t >>> Installing VSCode plugins"
source "$shared_dir/scripts/install-vscode-plugins.sh"


log_info "\t >>> Updating power settings"
enabled=1
disabled=0
autopoweroff=0  # Disable hibernation.
hibernatemode=0 # Disable memory backup to persistent storage.
standby=0       # Disable chipset sleep.

# NOTE: For more informations about the next settings run `man pmset`.

# Power settings when using the battery.
sudo pmset -b \
	displaysleep 3 \
	sleep 5 \
	lidwake $disabled \
	powernap $disabled \
	proximitywake $disabled \
	ring $disabled \
	womp $disabled \
	acwake $enabled \
	lessbright $enabled \
	autopoweroff $autopoweroff \
	hibernatemode $hibernatemode \
	standby $standby

# Power settings when connected to the charger.
sudo pmset -c \
	displaysleep 5 \
	sleep 10 \
	proximitywake $disabled \
	ring $disabled \
	womp $disabled \
	acwake $enabled \
	lidwake $enabled \
	lessbright $enabled \
	powernap $enabled \
	autopoweroff $autopoweroff \
	hibernatemode $hibernatemode \
	standby $standby


log_info "\t >>> Ignoring Focusrite Scarlett Solo automount"
echo "UUID=DC798778-543D-396B-A11F-2EC42F3500F9 none msdos ro,noauto" |
	sudo tee -a /etc/fstab >/dev/null


if [ -z "$(grep "$HOMEBREW_PREFIX/bin/bash" /etc/shells)" ]; then
	log_info "\t >>> Setting Homebrew's bash as the default shell"
	echo "$HOMEBREW_PREFIX/bin/bash" | sudo tee -a /etc/shells
	chsh -s "$HOMEBREW_PREFIX/bin/bash" "$(whoami)"
fi


echo "ok" > "$bootstrap_mark_file"
log_success "\t >>> Finished!"

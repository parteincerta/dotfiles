#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -e

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
rootdir="$(cd "$scriptdir/../../" && pwd)"
pushd "$scriptdir" >/dev/null
trap "popd >/dev/null" EXIT

source "$rootdir/shared/scripts/helper.sh"
trap "popd >/dev/null; trap_error" ERR


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
	log_warning ">>> To restart the process: \$ rm $bootstrap_mark_file"
	exit 1
fi

expected_hostname="mbp16-i9"
nice_hostname="${HOSTNAME/%.local/}"
if [ "$expected_hostname" != "$nice_hostname" ]; then
	# Apple MacBook Pro 16-inch (2019)
	# CPU: Intel Core i7-9980HK @2.40GHz
	# RAM: 64GB @2667MHz DDR4
	# GPU: Intel UHD Graphics 630
	# GPU: AMD Radeon Pro 5500M
	# SSD: 1TB NVMe
	log_warning ">>> This bootstrap script belongs to another host: $expected_hostname".
	log_warning ">>> The current host is: $nice_hostname"
	exit 1
fi

log_info "\t >>> Installing dotfiles"
/bin/bash configure.sh


log_info "\t >>> Configuring the Desktop and keyboard"
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.30
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write -g NSWindowShouldDragOnGesture -bool true
killall Dock


if [ -z "$(command -v brew)" ]; then
	log_info "\t >>> Installing Homebrew ..."
	homebrew_url="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
	/bin/bash -c "$(curl --fail --location --silent --show-error $homebrew_url)"
	source "$rootdir/shared_macos/.bash_profile" || true
fi


log_info "\t >>> Installing Homebrew command line tools ..."
homebrew_clt=(
	7zip aria2 bat bash bash-completion@2 bzip2 coreutils eza fd findutils fio
	fish fzf gettext git-delta gnupg gsed jq lf miniserve mise mkcert moreutils
	neovim oha pbzip2 pigz ripgrep shellcheck tokei xz zstd
)
brew install "${homebrew_clt[@]}"
brew unlink openssl@3


log_info "\t >>> Installing Homebrew apps ..."
brave="brave-browser"
compass="mongodb-compass-isolated-edition"
dbeaver="dbeaver-community"
docker="docker-desktop"
font="font-jetbrains-mono-nerd-font"
microsoft=(microsoft-excel microsoft-powerpoint microsoft-word windows-app)
vscode="visual-studio-code"
homebrew_casks=(
	alt-tab betterdisplay "$brave" bruno "$compass" "$dbeaver" "$docker" "$font"
	fork ghostty iina json-viewer mac-mouse-fix "${microsoft[@]}" mist numi obs
	parallels spaceid transmission "$vscode" zed
)
brew install --cask "${homebrew_casks[@]}"


log_info "\t >>> Sourcing environment variables and re-installing dotfiles"
source "$rootdir/shared_macos/.bash_profile" || true
/bin/bash configure.sh
bat cache --build


log_info "\t >>> Setting up the hosts file ..."
/bin/bash "$rootdir/shared/scripts/install-hosts.sh"


log_info "\t >>> Installing pip packages ..."
pip3 install --user wheel
pip3 install --user pynvim


log_info "\t >>> Installing mise packages ..."
MISE_YES=1 mise install
fish --command "bun completions"


log_info "\t >>> Installing vcpkg ..."
/bin/bash "$rootdir/shared/scripts/install-vcpkg.sh" --silent


log_info "\t >>> Installing MongoDB Shell and Tools .."
/bin/bash "$rootdir/shared/scripts/install-mongo-utils.sh" shell
/bin/bash "$rootdir/shared/scripts/install-mongo-utils.sh" tools


log_info "\t >>> Installing iSMC ..."
/bin/bash "$rootdir/shared_macos/scripts/install-ismc.sh"


log_info "\t >>> Installing Neovim plugins ..."
nvim --headless -c "Lazy! install" -c qall


log_info "\t >>> Updating power settings"
enabled=1
disabled=0
autopoweroff=0  # Disable hibernation.
hibernatemode=0 # Disable memory backup to persistent storage.
standby=0       # Disable chipset sleep.

# NOTE: Run `man pmset` to know more about the next set of `pmset` commands.
# pmset -b: Power settings when using the battery.
# pmset -c: Power settings when using the charger.

sudo pmset -b \
	displaysleep 3 \
	sleep 5 \
	gpuswitch $disabled \
	lidwake $enabled \
	powernap $disabled \
	proximitywake $disabled \
	ring $disabled \
	womp $disabled \
	acwake $disabled \
	lessbright $enabled \
	lowpowermode $enabled \
	autopoweroff $autopoweroff \
	hibernatemode $hibernatemode \
	standby $standby

sudo pmset -c \
	displaysleep 10 \
	sleep 10 \
	gpuswitch 2 \
	lidwake $enabled \
	powernap $enabled \
	proximitywake $disabled \
	ring $disabled \
	womp $enabled \
	acwake $disabled \
	lessbright $disabled \
	lowpowermode $disabled \
	autopoweroff $autopoweroff \
	hibernatemode $hibernatemode \
	standby $standby


log_info "\t >>> Ignoring Focusrite Scarlett Solo automount"
echo "UUID=DC798778-543D-396B-A11F-2EC42F3500F9 none msdos ro,noauto" |
	sudo tee -a /etc/fstab >/dev/null


if ! grep -q "$HOMEBREW_PREFIX/bin/bash" /etc/shells; then
	log_info "\t >>> Setting Homebrew's bash as the default shell"
	echo "$HOMEBREW_PREFIX/bin/bash" | sudo tee -a /etc/shells
	echo "$HOMEBREW_PREFIX/bin/fish" | sudo tee -a /etc/shells
	chsh -s "$HOMEBREW_PREFIX/bin/bash" "$(whoami)"
fi


if [ -f /etc/paths.d/homebrew ]; then
	# $PATH and Homebrew's directories are handled in .bash_profile/config.fish
	log_info "\t >>> Removing /etc/paths.d/homebrew ..."
	sudo rm /etc/paths.d/homebrew
fi


echo "ok" > "$bootstrap_mark_file"
log_success "\t >>> Finished!"

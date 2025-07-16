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

expected_hostname="mbp16-m2m"
nice_hostname="${HOSTNAME/%.local/}"
if [ "$expected_hostname" != "$nice_hostname" ]; then
	# Apple MacBook Pro 16-inch (2023)
	# CPU: Apple M2 Max (8P@3.7GHz + 4E@3.4GHz)
	# RAM: 96GB LPDDR5-6400 (400GB/s)
	# GPU: 38C
	# NPU: 15.8 TOPS
	# SSD: 2TB NVMe
	log_warning ">>> This bootstrap script belongs to another host: $expected_hostname".
	log_warning ">>> The current host is: $nice_hostname"
	exit 1
fi

log_info "\t >>> Installing dotfiles"
source configure.sh


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


log_info "\t >>> Installing Apple Rosetta"
/usr/sbin/softwareupdate --install-rosetta --agree-to-license


if [ -z "$(command -v brew)" ]; then
	log_info "\t >>> Installing Homebrew ..."
	homebrew_url="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
	/bin/bash -c "$(curl --fail --location --silent --show-error $homebrew_url)"
	source "$rootdir/shared_macos/.bash_profile" || true
fi


log_info "\t >>> Installing Homebrew command line tools ..."
homebrew_clt=(
	bat bash bash-completion@2 coreutils eza fd findutils fzf gettext git-delta
	gnupg gsed jq lf moreutils neovim ripgrep
)
brew install "${homebrew_clt[@]}"
brew unlink openssl@3


log_info "\t >>> Installing Homebrew apps ..."
fonts=(font-jetbrains-mono-nerd-font)
microsoft=(microsoft-excel microsoft-powerpoint microsoft-word)
homebrew_casks=(
	alt-tab betterdisplay "${fonts[@]}" google-chrome iina mac-mouse-fix
	"${microsoft[@]}" numi onyx spaceid zoom
)
brew install --cask "${homebrew_casks[@]}"


log_info "\t >>> Sourcing environment variables and re-installing dotfiles"
source "$rootdir/shared_macos/.bash_profile" || true
source configure.sh
bat cache --build


log_info "\t >>> Setting up the hosts file ..."
source "$rootdir/shared/scripts/install-hosts.sh"


if ! grep -q "$HOMEBREW_PREFIX/bin/bash" /etc/shells; then
	log_info "\t >>> Setting Homebrew's bash as the default shell"
	echo "$HOMEBREW_PREFIX/bin/bash" | sudo tee -a /etc/shells
	chsh -s "$HOMEBREW_PREFIX/bin/bash" "$(whoami)"
fi


echo "ok" > "$bootstrap_mark_file"
log_success "\t >>> Finished!"

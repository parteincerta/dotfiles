# macOS Setup Notes

## System Settings
- General
  - Programmatically set the hostname:
    - `sudo scutil --set HostName <hostname>.local`
    - `sudo scutil --set LocalHostName <hostname>`
    - `sudo scutil --set ComputerName <hostname>`
  - Disable all Software Updates.
- Networking
  - IPv4 DNS: `1.1.1.1` and `1.0.0.1`.
  - IPv6 DNS: `2606:4700:4700::1111` and `2606:4700:4700::1001`.
- Notifications: Disable all unecessary ones, configure the others.
- Sound: Disable macOS startup sound and reduce alert volume to half.
- Accessibility
  - Enable keyboard shortcut to zoom.
  - Enable trackpad's three-finger drag.
  - Enable _Reduce motion_ in the _Display_ section.
- Control Center
  - Show Bluetooth, Airdrop, Sound, Battery and VPN (when available).
  - Show time with seconds.
  - Hide Spotlight icon.
- Siri and Spotlight
  - Disable results for _Contacts_, _Definition_, _Folders_, _Fonts_, _Movies_,
    _Music_, _Siri Suggestions_, _System Settings_, _Tips_ and _Websites_.
  - Prevent Siri from learning from any application.
- Privacy and Security
  - Show location icon when System Services request my location.
  - Disable location access for _HomeKit_, _Mac Analytics_ and _Suggestions & Search_.
  - Set Apple Terminal permissions: _Full Disk Access_ and _Developer Tools_.
- Desktop & Dock
  - Scale down, add Applications folder and control icons' size with `Cmd+` and `Cmd-`.
  - Minimize using the _Scale Effect_.
  - Disable: Minimize windows into application icon.
  - Enable: Automatically hide and show the dock.
  - Disable: Animate opening application.
  - Enable: Show indicators for open application.
  - Disable: Show suggested and recent apps in Dock.
  - Click wallpaper to reveal desktop: Only in Stage Manager.
  - Disable: Stage Manager.
  - Prefer tabs when opening documents: Always.
  - Disable: Automatically rearrange Spaces based on most recent use.
  - Enable: Group windows by application.
  - Hot Corners: Set `Cmd + top right` to show the Desktop.
- Displays
  - Disable iPad interoperability.
  - Enable Night Shift with _Sunset to Sunrise_ and place the tempeature gauge
    right on top of _More Warm_.
- Lock Screen
  - Start Screen Saver when active: _Never_.
  - Require password: _After 5 seconds_.
- Game Center: Disable.
- Wallet & Apple Pay: Disable _Add Orders to Wallet_.
- Keyboard
  - Create five more virtual desktops before entering this section.
  - Set _Key repeat rate_ and _Delay until repeat_ to their max value.
  - Turn off keyboard backlight after _30 seconds_ of inactivity.
  - Set globe key to _Change Input Source_.
  - Keyboard Shortcuts
    - Mission Control
      - Disable F11 to Show Desktop (consider disabling some others too).
      - Enable all `^<n>` Desktop chords.
    - Input sources: Disable `^Space` and `^+Opt+Space` chords.
    - Function Keys: Use F-keys as standard function keys.
    - Modifier Keys: Map Caps Lock to Escape.
  - Disable all automatic actions in Input Sources.
  - Remove all Text Replacements.
- Trackpad
  - Set tracking speed to one point bellow the maximum.
  - Enable App Exposé with _Swipe Down with Four Fingers_.
- Mouse: Set tracking speed to two points bellow the maximum.

## Finder and Safari
- Settings
  - General
    - Show all items in Desktop.
    - New finder window shows: Home folder.
    - Enable: Open folders in tabs instead of windows.
  - Sidebar: Show home folder, show all disks and hide tags.
  - Advanced: When performing a search: Search in Current Folder.
  - View: Show Path Bar and Hide Preview.
  - Show View Options:
    - For Home and Applications folders:
      - Icons view. 
      - Set icon size to 40x40.
      - Reduce grid size by one point.
      - Sort items by _name_.
    - Other folders:
      - Column view.
      - Set _Always open in column view_.
      - Group By: _Kind_ / Sort By: _Name_.
      - Disable _Show icon preview_.
    - Specifically for the Desktop view:
      - Sort by: kind.
      - Icon size: 36x36.
      - Enable: Show item info.
      - Enable: Show item preview.
  - Add the following locations to Spotlight Privacy list:
    - System: `/opt`, `/usr/local`, `/Library` and `/System`.
    - User: `~/{Developer,Library,.cache,.config,.local,.m2,.ssh}`.
- Safari
  - View: Show status bar.
  - General
    - Safari opens with: _All windows from the last session_.
    - New windows open with: `Start page`.
    - New tabs open with: `Start page`.
    - Homepage: `https://github.com/parteincerta`.
    - Disable _Open "safe" files after downloading_.
  - Search
    - Search engine: _DuckDuckGo_.
    - Disable: Also use in Private Browsing.
    - Private search engine: _Google_.
    - Disable: Include search engine suggestions.
    - Disable: Preload Top Hit in the background.
    - Disable: Show start page.
  - Security: Disable: Warn when visiting a fraudulent website.
  - Privacy: Disable: Require Touch ID to view locked tabs.
  - Advanced
    - Disable: Allow websites to check for Apple Pay and Apple Card.
    - Enable: Save articles for offline reading automatically.
    - Enable: Show features for web developers.
  - Developer: Turn on _Disable site-specific quirks_.

## Development Environment
- Manually install the latest Command Line Tools from [Apple Developer][macos-notes-01].
  - Note: Using `xcode-select --install` would be easier but it's
    [causing problems][macos-notes-02] with Homebrew when upgrading packages.
- Clone this repo and run `./bootstrap.sh`. Setup 1st-party apps while the bootstrap is running.
- Import the `tokyo-night` profile for Apple Terminal and set it as default.
- Start neovim and let the installation of TreeSitter grammars and LSP servers finish.
- Clone personal repositories and set `git config user.name` and `git config user.email`.
- Set _Developer Tools_ permissions for Ghostty/Kitty.

## Wrap up
- Start by configuring: SpaceId, BetterDisplay, Mac Mouse Fix and AltTab.
- Disable automatic updates across all apps, when possible.
- Setup Docker.
  - Configure startup settings, resources, folder permissions and notifications.
  - Install the _Disk usage_, _Logs Explorer_ and _Resource Usage_ extensions.
- Install VSCode plugins:
  `bash shared/scripts/install-vscode-plugins.sh --silent [--plugins-list <file>]`.
- Set Brave's _Tab Scrolling_ to _tab shrink to pinned tab width_ in `brave://flags`.
- Configure Notifications, Login Items and Siri.
- Press `Cmd+Shift+5`, select `Options` and set folder used for screenshots/recordings.
- Install DBeaver's connections.
- Setup the [Docker containers][macos-notes-03].
- Configure VPNs and show the VPN icon in the Menu Bar.
- Clone and configure 3rd party git repositories.
- Setup 3rd party Remote Desktop connections.
- Shutdown internet connections and run Onyx.
  - Disable macOS GateKeeper.
  - Clean up temporary artifacts.
- Revoke Onyx permissions and shutdown the computer.
- [Disable SiP][macos-notes-04].
- Disable services: `bash macos/<hostname>/other/disable-services.sh`
- Reboot.

[macos-notes-01]: https://developer.apple.com/download/all
[macos-notes-02]: https://github.com/orgs/Homebrew/discussions/5723#discussioncomment-11185411
[macos-notes-03]: https://github.com/parteincerta/docker-recipes
[macos-notes-04]: https://developer.apple.com/documentation/security/disabling-and-enabling-system-integrity-protection

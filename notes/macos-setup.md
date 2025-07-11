# macOS Setup Notes

## System Settings
- WiFi, Bluetooth and Network
  - IPv4 DNS: `1.1.1.1` and `1.0.0.1`.
  - IPv6 DNS: `2606:4700:4700::1111` and `2606:4700:4700::1001`.
  - Disable: _Open when no keyboard is detected_.
  - Disable: _Open when no mouse or trackpad is detected_.
- Battery:
  - Low Power Mode: _Only on Battery_.
  - Enable: _Optimize video streaming while on battery_.
- General
  - Disable all Software Updates.
- Accessibility
  - Enable keyboard shortcut to zoom.
  - Enable trackpad's three-finger drag.
  - Enable _Reduce motion_ in the _Display_ section.
- Appearance: Set _Show scroll bars_ to _When scrolling_.
- Siri: Disable _Show Siri suggestions in application_ and _Learn from this
  application_ for all entries.
- Control Center
  - Show Bluetooth, Airdrop, Sound, Battery and VPN (when available).
  - Clock: Display the time with seconds.
  - Spolight: Don't show in Menu Bar.
  - Weather: Show in Menu Bar.
- Desktop & Dock
  - Dock
    - Position on screen: Bottom.
    - Minimize windows using: Scale Effect.
    - Enable: Automatically hide and show the Dock.
    - Disable: Animate opening applications.
    - Enable: Show indicators for open application.
    - Disable: Show suggested and recent apps in Dock.
  - Desktop and Stage Manager
    - Click wallpaper to reveal desktop: Only in Stage Manager.
    - Stage Manager: Disabled.
    - Show recent apps in Stage Manager: Disabled.
    - Show Widgets: Disabled for both Desktop and Stage Manager.
  - Widgets
    - Show Widgets: Disable both _On Desktop_ and _In Stage Manager_.
    - Use iPhone widgets: Disabled.
  - Windows
    - Prefer tabs when opening documents: _Always_.
    - Disable all tilling options.
  Mission Control
    - Disable: Automatically rearrange Spaced based on most recent use.
    - Enable: Group windows by application.
    - Hot Corners: `Cmd + top right` to show the Desktop.
- Displays
  - Disable iPad interoperability.
  - Night Shift: _Sunset to Sunrise_. Move the temperator slider to the
    beginning of _More Warm_.
- Spotlight
  - Disable results for _Contacts_, _Definition_, _Folders_, _Fonts_, _Movies_,
    _Music_, _Siri Suggestions_, _System Settings_, _Tips_ and _Websites_.
  - Disable: Help Apple improve Search.
- Sound
  - Disable: Play sound on startup.
  - Reduce alert volume to half.
- Lock Screen
  - Start Screen Saver when active: _Never_.
  - Require password: _After 5 seconds_.
- Privacy and Security
  - Enable: Show location icon in Control Center when System Services requests
    your location.
  - Disable location access for _Suggestions & Search_, _HomeKit_ and
    _Mac Analytics_.
  - Set Apple Terminal permissions: _Full Disk Access_ and _Developer Tools_.
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
- Other
  - Programmatically set the hostname
    - `sudo scutil --set HostName <hostname>.local`.
    - `sudo scutil --set LocalHostName <hostname>`.
    - `sudo scutil --set ComputerName <hostname>`.
  - Folders in the Dock
    - Add Applications, Documents and Downloads.
    - Set all to display as _Folder_.
    - For Applications, set _View content as_: _Grid_.
    - For Document and Downloads, set _View content as_: _List_.
    - Scale down Applications folder icons with `Cmd+`/`Cmd-`.

## Finder, iCloud and Safari
- Finder
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
    - System: `/opt`, `/usr/local`, `/Library` and `/System/Library/Frameworks`.
    - User: `~/{Developer,Library,.cache,.config,.local,.m2,.ssh}`.
- iCloud
  - Authenticate with the iCloud account.
  - Disable the synchronization of Stocks, Home, Wallet and Siri.
  - Consider disabling _Private Relay_.
  - Enable FireVault with iCloud authentication in Privacy & Security.
  - Allow Apple Watch to unlock macOS in TouchID & Password.
  - Sign out of Game Center.
- Safari
  - View: Show status bar.
  - General
    - Safari opens with: _All windows from the last session_.
    - New windows open with: _Start page_.
    - New tabs open with: _Start page_.
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
  - Add SpaceId to the _Login Items_ list and enable _Automatic launch at login_
    for BetterDisplay.
- Disable automatic updates across all apps, when possible.
- Setup Docker.
  - Configure startup settings, resources, folder permissions and notifications.
  - Move the Docker folder to the auxiliary/external volume (desktop hosts only).
  - Install the _Disk usage_, _Logs Explorer_ and _Resource Usage_ extensions.
- Install VSCode plugins:
  `bash shared/scripts/install-vscode-plugins.sh --silent [--plugins-list <file>]`.
- Setup Brave.
  - Set _Tab Scrolling_ to _tab shrink to pinned tab width_ in `brave://flags`.
  - Enable _Parallel downloading_ in `brave://flags`.
- Configure iCloud Sync, Notifications, Login Items and Siri.
- Press `Cmd+Shift+5`, select `Options` and select the folder where
  screenshots/recordings must be stored.
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

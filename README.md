# dotfiles
A set of configuration files and scripts that I use to seed and maintain my
development environment across all the computers I use.

## macOS
- Optionally follow the preliminary macOS [setup guide](macos/README.md).
- Install Apple CLI Tools `xcode-select --install`.
- Add the following location to Spotlight Privacy list `/Library/Developer`.
- Clone this repo and run: `bash macos/<hostname>/bootstrap.sh`.
- Start neovim and let the LSP servers install.
- Open applications and configure them as needed.
  - If the machine has an external drive, reinstall the dotfiles before
    accepting Docker's ToS just so it's disk is created in the external storage
    instead of in the internal one: `bash macos/<hostname>/configure.sh`.
  - Set Brave's `Tab Scrolling` flag to
    `Enabled - tabs shrink to pinned tab width`.
- Disable auto-updates: `bash shared_macos/scripts/disable-updates.sh`.
- Press `Cmd+Shift+5`, select `Options` and then set screenshots' folder.
- Clone the [docker-containers](https://github.com/parteincerta/docker-containers)
  repo and setup the Docker containers.
- Revisit Notifications, Login Items, Spotlight and re-access accordingly.
- Configure VPNs and show them in the Menu Bar.
- Reboot.

### Maintenance
- Check for macOS updates:
  * To list available updates: `softwareupdate --list`.
  * To install an update: `sudo softwareupdate --install <label>`.
- Homebrew maintenance commands:
  * Update Homebrew and the list of formulae: `brew update`.
  * List outdated formulae: `brew outdated --greedy`.
  * Upgrade all installed formulae and casks: `brew upgrade --greedy`.
  * Formulae w/ special upgrade instructions:
    * `brew install --ignore-dependencies jdtls maven`.
    * `brew unlink python@3.12 openssl@3`.
  * Purge cache: `brew cleanup [--dry-run]`.
  * List dependencies of a formula: `brew deps --tree <formula>`.
  * List installed dependencies of a formula: `brew uses --installed <formula>`.
  * List installed formulae which are not dependencies of others: `brew leaves`.
  * List artifacts of a formula: `brew ls <formula>`.
- Hosts file maintenance steps:
  * Check for [hosts files][macos-maintenance-01] updates.
  * Update the version reference in
    [install-hosts.sh](shared/scripts/install-hosts.sh).
  * Update the hosts file: `bash shared/scripts/install-hosts.sh`.
- mise maintenance commands:
  * List installed plugins: `mise plugins list`.
  * List all available plugins: `mise plugins list-all`.
  * Install a new plugin: `mise plugins install <plugin>`.
  * Update installed plugins: `mise plugins upgrade`.
  * List outdated installed tools: `mise outdated`.
  * Check latest available tool version: `mise latest <plugin>[@version]`.
  * Install latest available tool version: `mise instasll <plugin>[@version]`.
  * List available versions of a tool tools: `mise ls-remote <plugin>`.
  * Update all outdated tools: `mise upgrade`.
  * Update a given tool, if an update is available: `mise upgrade <plugin>@<version>`.
- mise for AMD64 maintenance commands:
  * Check for [mise][macos-maintenance-05] updates for the AMD64 version.
  * Update the version reference in
    [install-mise-amd64.sh](shared/scripts/install-mise-amd64.sh).
  * Update the AMD64 version: `bash shared/scripts/install-mise-amd64.sh`.
  * Use the same instructions used for regular mise to manage the AMD64 tools.
- MongoDB utilities maintenance steps:
  * Check for [MongoDB Shell][macos-maintenance-02] and
    [MongoDB Tools][macos-maintenance-03] updates.
  * Update the version references in
    [install-mongo-utils.sh](shared/scripts/install-mongo-utils.sh).
  * Update Shell: `bash shared/scripts/install-mongo-utils.sh shell`.
  * Update Tools: `bash shared/scripts/install-mongo-utils.sh tools`.
- Neovim maintenance commands:
  * Update Lazy's plugins: `:Lazy sync`.
  * Update Mason's registry: `:MasonUpdate`.
  * Update Mason's LSPs: `:Mason` -> Press the `U` key.
  * Update TreeSitter's parsers: `TSUpdateSync`.
- Python maintenance commands:
  * `pip3 list --user --outdated`.
  * `pip3 install --user --upgrade <package>`.
- vcpkg maintenance commands:
  * Check for [vcpkg][macos-maintenance-06] updates.
  * Update the version tag in [install-vcpkg.sh](shared/scripts/install-vcpkg.sh).
  * Update vcpkg: `bash shared/scripts/install-vcpkg.sh`.
- Other maintenance commands:
  * Install the dotfiles: `bash macos/<hostname>/configure.sh`.
  * Export configurations: `bash shared_macos/scripts/export-defaults.sh`.
  * Disable auto-updates: `bash shared_macos/scripts/disable-updates.sh`.
  * Update Brave's Content Filters lists.
- Check for VSCode plugins updates.
- Check for App Store updates.
- Check for [OpenCore Legacy Patcher][macos-maintenance-04] updates.

[macos-maintenance-01]: https://github.com/StevenBlack/hosts/releases
[macos-maintenance-02]: https://github.com/mongodb-js/mongosh/releases
[macos-maintenance-03]: https://github.com/mongodb/mongo-tools/tags
[macos-maintenance-04]: https://github.com/dortania/OpenCore-Legacy-Patcher/releases
[macos-maintenance-05]: https://github.com/jdx/mise/releases
[macos-maintenance-06]: https://github.com/microsoft/vcpkg/releases

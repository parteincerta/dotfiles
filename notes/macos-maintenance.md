# macOS Maintenance Notes

## Core Maintenance
- Update macOS
  - To list available updates: `softwareupdate --list`.
  - To install an update: `softwareupdate --install "<label>"`.
  - To install an update and restart: `sudo softwareupdate --install --restart "<label>"`.
  - Install the latest version of [OpenCore Legacy Patcher][macos-maintenance-04], if applicable.

- Update dotfiles and `/private/etc/hosts`
  - `cd $DEVELOPER/parteincerta/dotfiles && git pull && ./configure.sh`
  - Check for [Steven Black's hosts][macos-maintenance-01] updates and patch `install-hosts.sh`.
  - `bash shared/scripts/install-hosts.sh $SHORT_HOSTNAME`
  
- Update MongoDB utilities
  - Check for [MongoDB Shell][macos-maintenance-02] and
    [MongoDB Tools][macos-maintenance-03] updates and patch `install-mongo-utils.sh`.
  - Update Shell: `bash shared/scripts/install-mongo-utils.sh shell`.
  - Update Tools: `bash shared/scripts/install-mongo-utils.sh tools`.

- Update vcpkg
  - Check for [updates][macos-maintenance-05] and patch `install-vcpkg.sh`
  - `bash ./shared/scripts/install-vcpkg.sh`.

- Update Homebrew applications
  - Quit all apps.
  - Update Homebrew itself and the list of formulae: `brew update`.
  - Update all installed formulae and casks: `brew upgrade --greedy`.
  - Formulae w/ special upgrade instructions:
    * `brew install --ignore-dependencies gradle jdtls maven zls`.
    * `brew unlink python@3.13 openssl@3`.
  - Purge cache: `brew cleanup [--dry-run]`.

- Update mise plugins and tools
  - Update installed plugins: `mise plugins upgrade`.
  - Update all outdated tools: `mise upgrade`.
  - Update a particular tool: `mise upgrade <plugin>[@<version>]`.

- Update Neovim
  - Update Lazy's plugins: `:Lazy sync`.
  - Update Mason's registry: `:MasonUpdate`.
  - Update Mason's LSPs: `:Mason` -> Press the `U` key.
  - Update TreeSitter's parsers: `TSUpdateSync`.

- Update Python packages
  - List outdated packages: `pip3 list --user --outdated`.
  - Upgrade specific package `pip3 install --user --upgrade <package>`.

- Update Docker plugins and artifacts
  - Check for updated extensions in Docker Desktop.
  - Check for new versions of the [Docker images][macos-maintenance-06].
  - Run `docker compose up` for updated images.
  - Run `docker image prune --all` to remove unused images.
  - Run `docker system prune` to remove unused artifacts.

- Other update/maintenance tasks
  - Update Brave's Content Filters lists and clear its cache.
  - Update VSCode plugins.
  - Disable auto-updates: `bash shared_macos/scripts/disable-updates.sh`.
  - Export updated configurations: `bash shared_macos/scripts/export-defaults.sh`.
  - Purge caches from CLI tools: `purge bash clipboard nvim zsh` and `purge fish`.
  - Install App Store updates.

[macos-maintenance-01]: https://github.com/StevenBlack/hosts/releases
[macos-maintenance-02]: https://github.com/mongodb-js/mongosh/releases
[macos-maintenance-03]: https://github.com/mongodb/mongo-tools/tags
[macos-maintenance-04]: https://github.com/dortania/OpenCore-Legacy-Patcher/releases
[macos-maintenance-05]: https://github.com/microsoft/vcpkg/releases
[macos-maintenance-06]: https://github.com/parteincerta/docker-recipes

## Extra

### Homebrew
- List outdated formulae: `brew outdated --greedy`.
- List dependencies of a formula: `brew deps --tree <formula>`.
- List installed dependencies of a formula: `brew uses --installed <formula>`.
- List installed formulae which are not dependencies of others: `brew leaves`.
- List artifacts of a formula: `brew ls <formula>`.

### Mise
- List installed plugins: `mise plugins list`.
- List all available plugins: `mise plugins list-all`.
- Install a new plugin: `mise plugins install <plugin>`.
- Remove plugin: `mise remove <plugin>`.
- List outdated installed tools: `mise outdated`.
- Check latest available tool version: `mise latest <plugin>[@version]`.
- Install latest available tool version: `mise install <plugin>[@version]`.
- Remove tool version: `mise remove <plugin>@<version>`.
- List available versions of a tool tools: `mise ls-remote <plugin>`.

### SSH
- Generate new keys:
	- RSA: `ssh-keygen -t rsa-sha2-512 -b 8192 -C <hostname> -f id_rsa`
	- ED25519: `ssh-keygen -t ed25519 -C <hostname> -f id_ed25519`
- Set strict permissions for keys and their folder:
	- For the keys: `chmod u=r,g=,o= id_*`
	- For the folder where they're stored: `chmod u=rwx,g=,o= <folder>`
- Check the size of a RSA key: `ssh-keygen -l -f id_rsa.pub`

## Other
- Get Apple's Command Line Tools version: `pkgutil --pkg-info=com.apple.pkg.CLTools_Executables`

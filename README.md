# Installer
## Using the installer
Available scripts:
- `wifi`: Allows you to easily connect to a wifi network. The details are automatically copied from the installer to the actual machine when `install-os` is run.
- `download`: Downloads these dots to `~/dots`.
- `generate`: Generates the hardware configuration for the current machine using `nixos-generate-config` and saves them for a specific host.
- `install-os`: Install the configuration found in `~/dots`. If impermanence is enabled, the selected disk will be formatted before the installation. The modified dots and WIFI configurations will also be copied over.
All programs which are available when using the NixOS minimal installer ISO are available, as well as:
- git
- disko
- neovim
- fzf
- nixfmt

# Installer
## Using the installer
Available scripts:
- `wifi`: Allows you to easily connect to a wifi network. The details are automatically copied from the installer to the actual machine when `install-os` is run.
- `download`: Downloads this config to `~/config`.
- `generate`: Generates the hardware configuration for the current machine using `nixos-generate-config` and saves it for a specific host.
- `install-os`: Install the configuration found in `~/config`. If impermanence is enabled, the selected disk will be formatted before the installation. The modified config and WIFI configurations will also be copied over.

{
  inputs = {
    # Core
    lib.url = "./lib";
    lib.inputs = {
      nixpkgs.follows = "nixpkgs";
      wrappers.follows = "wrappers";
      home-manager.follows = "home-manager";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "lib";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Formatting
    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";
    nestix.url = "github:Noah765/nestix";
    nestix.inputs.nixpkgs.follows = "nixpkgs";

    # Impermanence
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    preservation.url = "github:nix-community/preservation";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland/v0.55.4";
    hy3.url = "github:outfoxxed/hy3/hl0.55.0";
    hy3.inputs.hyprland.follows = "hyprland";
    hypr-darkwindow.url = "github:micha4w/Hypr-DarkWindow/1ca9cdbf551fe8401e1685e9ede8265bc2069699";
    hypr-darkwindow.inputs.hyprland.follows = "hyprland";

    # Terminal multiplexer
    zellij-sessionizer.url = "github:victor-falcon/zellij-sessionizer";
    zellij-sessionizer.flake = false;
    zellij-switch.url = "github:mostafaqanbaryan/zellij-switch";
    zellij-switch.inputs = {
      nixpkgs.follows = "nixpkgs";
      rust-overlay.follows = "rust-overlay";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # Browser
    ublock-origin-assets.url = "github:uBlockOrigin/uAssets";
    ublock-origin-assets.flake = false;
    greasemonkey-scripts.url = "github:afreakk/greasemonkeyscripts";
    greasemonkey-scripts.flake = false;

    # Theming
    jjui-catppuccin-theme.url = "https://raw.githubusercontent.com/vic/tinted-jjui/refs/heads/main/themes/base24-catppuccin-mocha.toml";
    jjui-catppuccin-theme.flake = false;
    jjui-everforest-theme.url = "https://raw.githubusercontent.com/vic/tinted-jjui/refs/heads/main/themes/base16-everforest.toml";
    jjui-everforest-theme.flake = false;
    jjui-gruvbox-theme.url = "https://raw.githubusercontent.com/vic/tinted-jjui/refs/heads/main/themes/base24-gruvbox-dark.toml";
    jjui-gruvbox-theme.flake = false;
    qutebrowser-catppuccin-theme.url = "https://raw.githubusercontent.com/catppuccin/qutebrowser/refs/heads/main/setup.py";
    qutebrowser-catppuccin-theme.flake = false;
    qutebrowser-everforest-theme.url = "https://raw.githubusercontent.com/tinted-theming/base16-qutebrowser/refs/heads/main/themes/minimal/base16-everforest.config.py";
    qutebrowser-everforest-theme.flake = false;
    qutebrowser-gruvbox-theme.url = "https://raw.githubusercontent.com/The-Compiler/dotfiles/refs/heads/master/qutebrowser/gruvbox.py";
    qutebrowser-gruvbox-theme.flake = false;
    yazi-catppuccin-theme.url = "github:yazi-rs/flavors?dir=catppuccin-mocha.yazi";
    yazi-catppuccin-theme.flake = false;
    yazi-everforest-theme.url = "github:Chromium-3-Oxide/everforest-medium.yazi";
    yazi-everforest-theme.flake = false;
    yazi-gruvbox-theme.url = "github:bennyyip/gruvbox-dark.yazi";
    yazi-gruvbox-theme.flake = false;

    # Misc
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    desktop-shell.url = "github:Noah765/shell";
    desktop-shell.inputs = {
      nixpkgs.follows = "nixpkgs";
      treefmt.follows = "treefmt";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}

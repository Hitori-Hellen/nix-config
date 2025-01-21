{
  inputs,
  config,
  pkgs,
  ...
}: {
  # TODO please change the username & home directory to your own
  home.username = "linux";
  home.homeDirectory = "/home/linux";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';
  nixpkgs.config = {allowUnfree = true;};
  # nixpkgs.overlays = [inputs.neovim-nightly-overlay.overlays.default];
  nixpkgs.overlays = [inputs.hyprpanel.overlay];
  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  # programs.neovim = {defaultEditor = true;};
  programs.vscode = {
    enable = true;
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };
  programs.fastfetch = {
    enable = true;
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-unikey fcitx5-mozc fcitx5-gtk];
  };
  # Packages that should be installed to the user profile.
  home.packages = with pkgs;
    [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      gcc

      nnn # terminal file manager

      # archives
      zip
      xz
      unzip
      p7zip

      neovim
      vesktop
      slack
      # utils
      fastfetch
      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output

      btop # replacement of htop/nmon
      hyprpanel
      brightnessctl
      wev

      # IDE
      jetbrains.rust-rover
      jetbrains.webstorm
    ]
    ++ [inputs.zen-browser.packages."${system}".default];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "hitorihellen";
    userEmail = "leviettungduong@gmail.com";
  };

  # starship - an customizable prompt for any shell
  xdg.configFile = {
    "rofi/config.rasi".enable = false;
  };
  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Frappe";
    settings = {
      window_padding_width = 20;
    };
  };

  programs.cava = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

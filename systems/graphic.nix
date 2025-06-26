{ pkgs, ... }:
{
  imports = [
    ./commons.nix
    ./packages/wayland.nix
  ];

  environment.systemPackages = with pkgs; [
    emacs-git
    tdf
    digital
    musescore
    libreoffice
    lutris

    nyxt
    tor-browser-bundle-bin
    ente-auth
    mpv
    ff2mpv-rust
    fragments
    signal-desktop
    gurk-rs

    # Theming
    adwaita-icon-theme
    gnome-themes-extra
    libsForQt5.qt5ct
    qt6ct
  ];

  programs = {
    foot = {
      enable = true;
      theme = "modus-vivendi";
      settings.main.font = "monospace:size=14";
    };

    firefox = {
      enable = true;
      package = pkgs.librewolf;
    };

    thunderbird.enable = true;
    obs-studio.enable = true;
    kdeconnect.enable = true;
    steam.enable = true;
  };

  services = {
    gnome.gnome-keyring.enable = true; # Required by Ente Auth
    flatpak = {
      enable = true;
      update.onActivation = true;
      uninstallUnmanaged = true;
      packages = [ ];
    };
  };
}

{ pkgs, ... }:
{
  imports = [ ./commons.nix ];

  environment.systemPackages = with pkgs; [
    emacs-git
    tdf
    digital
    musescore
    libreoffice
    lutris

    nyxt
    tor-browser
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
    river = {
      enable = true;
      extraPackages = with pkgs; [
        pamixer
        kanshi
        yambar
        wofi
        fnott
        wayshot
        slurp
        wl-clipboard-rs
        swayidle
        warpd
      ];
    };

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
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
    };
    kdeconnect.enable = true;
    steam.enable = true;
  };

  services = {
    wlock.enable = true;
    gnome.gnome-keyring.enable = true; # Required by Ente Auth
    flatpak = {
      enable = true;
      update.onActivation = true;
      uninstallUnmanaged = true;
      packages = [ ];
    };
  };
}

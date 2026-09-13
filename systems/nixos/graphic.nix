{ pkgs, ... }:
{
  imports = [ ./commons.nix ];

  environment.systemPackages = with pkgs; [
    tdf
    digital
    musescore
    libreoffice
    prismlauncher
    opencode
    t3code
    lutris
    anki

    nyxt
    tor-browser
    brave-origin
    mpv
    fragments
    signal-desktop
    gurk-rs

    # Theming
    adwaita-icon-theme
    gnome-themes-extra
    libsForQt5.qt5ct
    qt6Packages.qt6ct
  ];

  programs = {
    kwm = {
      enable = true;
      withUWSM = true;
      extraPackages = with pkgs; [
        alacritty-graphics
        kwim
        pamixer
        kanshi
        yambar
        wmenu
        fnott
        wayshot
        slurp
        wl-clipboard-rs
        swayidle
        wayland-pipewire-idle-inhibit
        wl-kbptr
      ];
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
    ente-auth.enable = true;
    kdeconnect.enable = true;
    steam.enable = true;
  };

  xdg.portal.wlr.settings.screencast.chooser_type = "none";

  services = {
    emacs.package = pkgs.emacs-git;
    wlock.enable = true;
    flatpak = {
      enable = true;
      update.onActivation = true;
      uninstallUnmanaged = true;
      packages = [ ];
    };
  };
}

{ pkgs, ... }:
{
  imports = [ ./commons.nix ];

  environment.systemPackages = with pkgs; [
    tdf
    digital
    musescore
    libreoffice
    prismlauncher
    lutris
    anki

    nyxt
    tor-browser
    brave-origin
    mpv
    signal-desktop
    gurk-rs

    # Android
    android-tools
    scrcpy

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
      nativeMessagingHosts.packages = [ pkgs.ff2mpv-rust ];
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

    # Grant uaccess to MTP devices, which systemd only does for adb
    udev.packages = [ pkgs.libmtp ];
  };

  # Authentication agent for polkit prompts such as Signal Desktop backups
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}

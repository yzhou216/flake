{ pkgs, ... }:
{
  imports = [ ./commons.nix ];

  #environment.systemPackages = with pkgs; [
  #  tdf
  #  digital
  #  musescore
  #  libreoffice
  #  lutris

  #  nyxt
  #  tor-browser
  #  ente-auth
  #  mpv
  #  fragments
  #  signal-desktop
  #  gurk-rs

  #  # Theming
  #  adwaita-icon-theme
  #  gnome-themes-extra
  #  libsForQt5.qt5ct
  #  qt6Packages.qt6ct
  #];

  programs = {
    river = {
      enable = true;
      extraPackages = with pkgs; [
        alacritty-graphics
        pamixer
        kanshi
        yambar
        wmenu
        fnott
        wayshot
        slurp
        wl-clipboard-rs
        swayidle
        warpd
      ];
    };

    #firefox = {
    #  enable = true;
    #  package = pkgs.librewolf;
    #};

    #thunderbird.enable = true;
    #obs-studio = {
    #  enable = true;
    #  plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
    #};
    #kdeconnect.enable = true;
    #steam.enable = true;
  };

  #services = {
  #  emacs.package = pkgs.emacs-git;
  #  wlock.enable = true;
  #  gnome.gnome-keyring.enable = true; # Required by Ente Auth
  #  flatpak = {
  #    enable = true;
  #    update.onActivation = true;
  #    uninstallUnmanaged = true;
  #    packages = [ ];
  #  };
  #};
}

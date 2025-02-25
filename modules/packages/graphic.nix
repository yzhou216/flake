{pkgs, ...}: {
  imports = [./commons.nix];

  environment.systemPackages = with pkgs; [
    emacs-git

    # Theming
    adwaita-icon-theme
    gnome-themes-extra
    libsForQt5.qt5ct
    qt6ct

    alacritty
    fragments
    digital
    libreoffice
    nyxt
    tor-browser
    signal-desktop
    gurk-rs
    lutris
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
      ];
    };

    thunderbird.enable = true;
    kdeconnect.enable = true;
    steam.enable = true;
  };

  services.flatpak = {
    enable = true;
    update.onActivation = true;
    uninstallUnmanaged = true;
    packages = ["app.zen_browser.zen"];
  };
}

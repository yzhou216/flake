{pkgs, ...}: {
  imports = [./commons.nix];

  environment.systemPackages = with pkgs; [
    emacs-git
    tdf
    digital
    musescore
    libreoffice
    lutris

    nyxt
    tor-browser
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
      ];
    };

    foot = {
      enable = true;
      theme = "modus-vivendi";
      settings = {
        main = {
          font = "monospace:size=14";
        };
      };
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

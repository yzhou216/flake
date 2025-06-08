{ pkgs, ... }:
{
  imports = [ ./commons.nix ];

  environment.systemPackages =
    builtins.map (packageName: pkgs.${packageName})
      (builtins.fromTOML (builtins.readFile ./packages.toml)).graphic;

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
      plugins = [ pkgs.obs-studio-plugins.wlrobs ];
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

{ pkgs, ... }:
{
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

    obs-studio.plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
  };

  services.wlock.enable = true;
}

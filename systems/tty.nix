{ pkgs, ... }:
{
  imports = [ ./commons.nix ];
  environment.systemPackages = with pkgs; [ emacs-git-nox ];
}

{ pkgs, ... }:
{
  imports = [ ./commons.nix ];
  services.emacs.package = pkgs.emacs-git-nox;
}

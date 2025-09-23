{
  pkgs,
  ...
}:

let
  inherit (pkgs) stdenv;
in
{
  documentation = {
    enable = true;
    man.enable = true;
    info.enable = true;
    doc.enable = true;
  }
  // (if stdenv.isLinux then { dev.enable = true; } else { });
}

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
  // (if stdenv.hostPlatform.isLinux then { dev.enable = true; } else { });
}

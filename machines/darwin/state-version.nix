{ ... }:
{
  /*
     This value determines the nix-darwin release from which the
     default settings for stateful data, like file locations and
     database versions on your system were taken.  It's perfectly fine
     and recommended to leave this value at the release version of the
     first install of this system.  Before changing this value, read
     the documentation for this option (e.g. man configuration.nix or
     on
     https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.stateVersion).
  */
  system.stateVersion = 4; # Did you read the comment?
}

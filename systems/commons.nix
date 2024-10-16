{...}: {
  nix.settings = {
    experimental-features = "nix-command flakes";
    nix-path = "nixpkgs=flake:nixpkgs";
    auto-optimise-store = true;
    trusted-users = ["root" "@wheel"];
  };
}

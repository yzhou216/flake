{pkgs, ...}: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Darwin preferences and config items
  networking.hostName = "m1";
  programs.zsh.enable = true;
  services.tailscale.enable = true;
  services.karabiner-elements.enable = true;
  environment = {
    shells = with pkgs; [bash zsh];
    loginShell = pkgs.zsh;

    systemPackages = with pkgs; [
      coreutils
      stow
      alacritty
      neovim
      alejandra
    ];

    systemPath = ["/opt/homebrew/bin"];
    pathsToLink = ["/Applications"];
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  fonts.fontDir.enable = true; # DANGER
  fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Meslo"];})];
  services.nix-daemon.enable = true;
  system.defaults = {
    finder._FXShowPosixPathInTitle = true;
    finder.AppleShowAllExtensions = true;
    finder.ShowStatusBar = true;
    finder.ShowPathbar = false;
    finder.CreateDesktop = false;
    finder.QuitMenuItem = true;

    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark"; # dark mode
    NSGlobalDomain._HIHideMenuBar = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain."com.apple.swipescrolldirection" = false; # Disable natural scrolling
    dock.autohide = true;

    #TODO
    #".GlobalPreferences"."com.apple.mouse.scaling" = 5.0;
  };

  # backwards compat; **DO NOT CHANGE!!**
  system.stateVersion = 4;

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "firefox"
      "thunderbird"
      "libreoffice"
      "quicksilver"
      "amethyst"
      "scroll-reverser"
      "signal"
    ];
    taps = ["fujiapple852/trippy"];
    brews = ["trippy"];
  };
}

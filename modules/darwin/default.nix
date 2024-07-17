# Darwin preferences and config items
{pkgs, ...}: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  networking.hostName = "m1";

  programs.zsh.enable = true;

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

  services = {
    nix-daemon.enable = true;
    tailscale.enable = true;
    karabiner-elements.enable = true;
  };

  fonts.fontDir.enable = true; # DANGER
  fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Meslo"];})];

  # backwards compat; **DO NOT CHANGE!!**
  system.stateVersion = 4;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark"; # dark mode
      _HIHideMenuBar = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
      "com.apple.swipescrolldirection" = false; # Disable natural scrolling
      NSAutomaticWindowAnimationsEnabled = false;
      NSDisableAutomaticTermination = true;
      NSDocumentSaveNewDocumentsToCloud = false;
    };

    finder = {
      _FXShowPosixPathInTitle = true;
      AppleShowAllExtensions = true;
      ShowStatusBar = true;
      ShowPathbar = false;
      CreateDesktop = false;
      QuitMenuItem = true;
    };

    dock = {
      autohide = true;
      show-recents = false;
      orientation = "right";
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };

    #TODO
    #".GlobalPreferences"."com.apple.mouse.scaling" = 5.0;
  };

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

# Darwin preferences and config items
{
  pkgs,
  ...
}:
{
  imports = [
    ../nixpkgs.nix
    ../shell.nix
    ../dev.nix
    ../vc.nix
    ../editors.nix
    ../man.nix
  ];

  programs.tmux.enable = true;

  environment = {
    shells = with pkgs; [ bash ];
    systemPackages = with pkgs; [
      coreutils
      emacs-macport
      alacritty-graphics
      jankyborders

      readline
      tree
      zstd
      skim
      ffmpeg

      # network
      wget
      sshfs
      dumbpipe
      miniserve

      # spell checker
      aspell
      aspellDicts.en

      # NixOS
      nixos-anywhere
      #nixos-facter
      nix-init

      # TeX
      tectonic
      texlab
      #lilypond-unstable-with-fonts

      # graphics
      firefox
      thunderbird
      mpv
      gurk-rs
      tdf
      digital
      musescore
      swift-quit
    ];

    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
  };

  fonts.packages = with pkgs; [ nerd-fonts.hack ];

  services = {
    emacs.package = pkgs.emacs-macport;
    tailscale.enable = true;
    yabai.enable = true;
    yabai.enableScriptingAddition = true;
    skhd.enable = true;
    sketchybar.enable = true;
  };

  system = {
    startup.chime = false;

    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;

    defaults = {
      universalaccess = {
        reduceMotion = true;
        reduceTransparency = true;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleInterfaceStyle = "Dark"; # dark mode
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleEnableSwipeNavigateWithScrolls = false;
        _HIHideMenuBar = true;
        InitialKeyRepeat = 14;
        KeyRepeat = 1;
        "com.apple.swipescrolldirection" = false; # Disable natural scrolling
        "com.apple.trackpad.forceClick" = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDisableAutomaticTermination = true;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
        NSUseAnimatedFocusRing = false;
        NSWindowResizeTime = 0.001; # Make dialogs instantly appear
      };

      loginwindow.SHOWFULLNAME = true; # Remove name on login screen

      LaunchServices.LSQuarantine = false;

      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        ShowStatusBar = true;
        ShowPathbar = false;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf"; # Current directory
        QuitMenuItem = true;
      };

      dock = {
        autohide = true;
        autohide-time-modifier = 0.0; # Disable Dock autohide animation
        autohide-delay = 1.7976931348623157e308; # Disable Dock (kind of)
        show-recents = false;
        static-only = true; # Show running programs only
        show-process-indicators = false;
        launchanim = false;
        mineffect = "scale";
        mru-spaces = false; # Disable automatic space rearrangement
        orientation = "right";
        tilesize = 16;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };

      screencapture = {
        disable-shadow = true;
        location = "~/Pictures";
      };

      # 5 "ticks" in GUI
      ".GlobalPreferences"."com.apple.mouse.scaling" = 1.0;

      # Disable pointer acceleration
      CustomUserPreferences.NSGlobalDomain."com.apple.mouse.linear" = true;
    };
  };

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [
      "libreoffice"
      "scroll-reverser"
      "discretescroll"
      "signal"
      "steam"
    ];

    # TODO: broken! migrate taps to using nix-homebrew
    # taps = ["fujiapple852/trippy"];
    # brews = ["trippy"];
  };
}

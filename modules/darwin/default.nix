# Darwin preferences and config items
{pkgs, ...}: {
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    trusted-users = ["root" "@wheel"];
  };

  networking.hostName = "m1";

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      interactiveShellInit = ''
        if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
          PROMPT_COLOR="1;31m"
          ((UID)) && PROMPT_COLOR="1;32m"
          if [ -n "$INSIDE_EMACS" ]; then
            # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
            PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
          else
            PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
          fi
          if test "$TERM" = "xterm"; then
            PS1="\[\033]2;\h:\u:\w\007\]$PS1"
          fi
        fi
      '';
    };
    tmux.enable = true;
  };

  environment = {
    shells = with pkgs; [bash];
    systemPackages = with pkgs; [
      coreutils
      git
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

  # backwards compat; **DO NOT CHANGE!!**
  system.stateVersion = 4;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark"; # dark mode
      AppleInterfaceStyleSwitchesAutomatically = false;
      _HIHideMenuBar = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
      "com.apple.swipescrolldirection" = false; # Disable natural scrolling
      NSAutomaticWindowAnimationsEnabled = false;
      NSDisableAutomaticTermination = true;
      NSDocumentSaveNewDocumentsToCloud = false;
    };

    loginwindow.SHOWFULLNAME = true; # Remove name on login screen

    LaunchServices.LSQuarantine = false;

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
      "steam"
    ];
    taps = ["fujiapple852/trippy"];
    brews = ["trippy"];
  };
}

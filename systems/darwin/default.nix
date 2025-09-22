# Darwin preferences and config items
{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../bash.nix
    ../vc.nix
  ];

  programs.tmux.enable = true;

  environment = {
    shells = with pkgs; [ bash ];
    systemPackages = with pkgs; [
      coreutils
      emacs-macport
      alacritty-graphics
      neovim
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

      # source code tagging
      universal-ctags
      cscope

      # toolchain
      gcc
      gdb
      gnumake
      cmake
      libtool

      # manuals
      man-pages
      man-pages-posix
      #linux-manual

      # NixOS
      nixos-anywhere
      #nixos-facter
      nix-init

      # C
      libclang
      bear

      # Bash
      bash-language-server
      shfmt

      # TeX
      tectonic
      texlab
      #lilypond-unstable-with-fonts

      # Rust
      rustup
      bacon
      dioxus-cli

      # Go
      go
      gopls
      delve
      gofumpt
      golines

      # Lisp
      guile
      #akkuPackages.scheme-langserver
      #racket
      sbcl

      # Python
      rustpython
      uv
      pylyzer
      python3.pkgs.debugpy

      # Haskell
      ihaskell # bin/ghci
      haskellPackages.stack
      haskellPackages.haskell-language-server

      # Java
      temurin-bin # OpenJDK
      jdt-language-server

      # WWW
      vscode-langservers-extracted

      # SQL
      sqlite
      sqls

      # Markdown
      glow
      marksman

      # Nix
      nil
      nixfmt-rfc-style
      devenv

      # graphics
      mpv
      gurk-rs
      tdf
      digital
      musescore
    ];

    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
  };

  fonts.packages = with pkgs; [ nerd-fonts.hack ];

  services = {
    #tailscale.enable = true; # Enable after ssh and exit node support is ready
    yabai.enable = true;
    yabai.enableScriptingAddition = true;
    skhd.enable = true;
    sketchybar.enable = true;
    karabiner-elements.enable = true;
  };

  system = {
    # Add aliases for programs in Nix store
    activationScripts.postActivation.text = ''
      app_folder="$HOME/Applications/Nix Trampolines"
      rm -rf "$app_folder"
      mkdir -p "$app_folder"
      find "${config.system.build.applications}/Applications" -type l -print0 |
      while IFS= read -r -d "" app; do
          app_target="$app_folder/$(basename "$app")"
          real_app="$(readlink "$app")"
          echo "mkalias \"$real_app\" \"$app_target\"" >&2
          ${pkgs.mkalias}/bin/mkalias "$real_app" "$app_target"
      done
    '';

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
      "firefox"
      "thunderbird"
      "libreoffice"
      "tailscale" # Temporary solution
      "scroll-reverser"
      "discretescroll"
      "swift-quit"
      "signal"
      "steam"
    ];

    # TODO: broken! migrate taps to using nix-homebrew
    # taps = ["fujiapple852/trippy"];
    # brews = ["trippy"];
  };
}

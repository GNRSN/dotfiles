{ system, self }:
{ pkgs, ... }:

{
  # Suppress warning about migration that will need to be performed when upgrading MacOS to Sequoia
  ids.uids.nixbld = 300;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Manage nix-envs based on directory
    direnv
  ];

  fonts.packages = with pkgs; [
    # REVIEW: Consider narrowing to only install used fonts
    nerdfonts
  ];

  # TODO: How does this work? Should I remove it from systemPackages
  # see https://daiderd.com/nix-darwin/manual/index.html#opt-programs.direnv.enable
  # programs.direnv.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Set the version of nix we want to use
  nix.package = pkgs.nixVersions.nix_2_24;

  # Write directly into the nix.conf, try to replicate what NixInstaller left there
  # Some discrepancies between installer and NixDarwin
  # @see https://github.com/LnL7/nix-darwin/issues/889#issuecomment-2002505165
  nix.settings = {
    extra-nix-path = "nixpkgs=flake:nixpkgs";
    experimental-features = "nix-command flakes";
    upgrade-nix-store-path-url = "https://install.determinate.systems/nix-upgrade/stable/universal";
    allowed-users = [ "*" ];
  };

  # default shell on catalina
  programs.zsh.enable = true;

  # This property defines the version of nix to use, defaults to something pretty reasonable
  # system.nixpkgsRelease = 

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  nix.configureBuildUsers = true;
  nix.useDaemon = true;

  users.users = {
    gnrsn = {
      home = "/Users/gnrsn";
    };
  };

  homebrew.enable = true;
  # Uninstall anything not specified in nix, leaves associated files
  homebrew.onActivation.cleanup = "uninstall";

  homebrew.brews = [
    {
      # Focus follows mouse, essential for multi monitor work
      # NOTE: The cask versions option for starting at login did not work
      name = "dimentium/autoraise/autoraise";
      restart_service = "changed";
    }
  ];

  homebrew.casks = [
    # Tiling window manager
    "nikitabobko/tap/aerospace"
    # Browser of choice
    "arc"
    # Still the best AI(?)
    "chatgpt"
    # I want to try out the experience
    "cursor"
    # Translation
    "deepl"
    # Matrix client
    "element"
    # Figma
    "figma"
    # Keyboard remapping
    "hhkb"
    # For frontend development
    "google-chrome"
    # Modern Keepass UI
    "keepassxc"
    # Note-taking app
    "obsidian"
    # MacOS command pallette (spotlight replacement)
    "raycast"
    # I still use this for merge conflicts (ashamed)
    "visual-studio-code"
    # Terminal emulator of choice
    "wezterm"
  ];

  # Touch id for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # === UI ===

  # Dark mode
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = false;

  # Show scrollbars
  system.defaults.NSGlobalDomain.AppleShowScrollBars = "Always";

  # === Input

  # LATER: Lessons from fresh install
  # - Disable ctrl+space defaulting to switching input device
  # - Disable spotlight shortcut (makes it hard to start raycast for the first time though?)
  # - Change dictation shortcut from double tapping ctrl to mic icon (idk what button that is)
  # - Spotlight show in menu bar: false
  # - Sound: always show in the menu bar
  # - Remove keyboard shortcuts for mission control
  # - Mission control group windows by application (defaults write com.apple.dock expose-group-apps -bool true)
  # - Disable displays have separate spaces (defaults write com.apple.spaces spans-displays -bool true)

  # Control key repeat speed
  # Values based on https://apple.stackexchange.com/questions/261163/default-value-for-nsglobaldomain-initialkeyrepeat
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  # Remap caps to ctrl
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  system.keyboard.nonUS.remapTilde = true;
  system.keyboard.userKeyMapping = [ ];

  # Disable press and hold for diacritics.
  # I want to be able to press and hold j and k
  # in VSCode with vim keys to move around.
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  # Disable swipe left triggering "back"
  system.defaults.NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;

  # Click on scrollbar jumps to where clicked instead of just moving in direction
  system.defaults.NSGlobalDomain.AppleScrollerPagingBehavior = true;

  # Disable clicking on desktop hides all windows
  system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;

  # Disable hot corners, 1 is disabled
  system.defaults.dock.wvous-bl-corner = 1;
  system.defaults.dock.wvous-br-corner = 1;
  system.defaults.dock.wvous-tl-corner = 1;
  system.defaults.dock.wvous-tr-corner = 1;

  # === Dock ===

  # Dock icon size
  system.defaults.dock.tilesize = 16;

  # Hide dock unless hovered
  system.defaults.dock.autohide = true;

  # Prevent re-arranging spaces based on recently used,
  # weird that this option is under dock but w/e
  system.defaults.dock.mru-spaces = false;

  # Least obtrusive IMO
  system.defaults.dock.orientation = "left";

  # Default is null, 
  # REVIEW: hopefully this results in none?
  system.defaults.dock.persistent-apps = [ ];

  # I want it to be as empty as possible :P
  system.defaults.dock.show-recents = false;
  system.defaults.dock.static-only = true;

  # === Finder ===

  # Show file extensions
  system.defaults.finder.AppleShowAllExtensions = true;

  # Sort folders first
  # TODO: caused error, config option didn't exist
  #system.defaults.finder._FXSortFoldersFirst = true;

  # Show path in title
  system.defaults.finder._FXShowPosixPathInTitle = true;

  # Breadcrumbs for path
  system.defaults.finder.ShowPathbar = true;

  # Status bar
  system.defaults.finder.ShowStatusBar = true;

  # === Screen capture ===
  system.defaults.screencapture.location = "~/Pictures";
}

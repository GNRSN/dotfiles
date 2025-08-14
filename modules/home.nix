# Note the double lambda, home manager expects a function so to pass custom args we need a function returning a function
{ sqld_pkgs }:
{ pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  home.username = "gnrsn";

  home.homeDirectory = "/Users/gnrsn";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05";

  # Whitelist packages with restrictive licenses
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "graphite-cli"
      "mongodb-ce"
      "mongosh"
    ];

  home.packages = [
    # Debug, Adds the 'hello' command to your environment.
    # pkgs.hello

    # AI pair programming
    pkgs.aider-chat
    # Better cat, colors etc
    pkgs.bat
    # Resource monitor tui
    pkgs.btop
    # Logs parser util, nixpkgs only had the rust port which is not feature complete but should suffice
    # NOTE: For work
    pkgs.bunyan-rs
    # Shell completion generator
    pkgs.carapace
    # GNU utils, MacOS only ships with a subset + keep versions fresh
    pkgs.coreutils
    # Better git diff visualisation, usable by e.g. lazygit as well
    pkgs.delta
    # Another, even smarter git diff visualisation tool, built on tree sitter
    pkgs.difftastic
    # Better ls
    pkgs.eza
    # Better find
    pkgs.fd
    # Fuzzy finder
    pkgs.fzf
    # Keep version fresh, xcode updates slowly
    pkgs.git
    # Scan for secrets in git commits/history
    pkgs.gitleaks
    # Github cli
    pkgs.gh
    # Github tui extension for gh cli
    # TODO: How do I add this to gh?
    pkgs.gh-dash
    # Markdown renderer
    pkgs.glow
    # GNU Privacy guard, "backend" for password-store
    pkgs.gnupg
    # Graphite cli
    pkgs.graphite-cli
    # MacOS border for active window
    pkgs.jankyborders
    # json processor/query tool
    pkgs.jq
    # jq TUI playground
    pkgs.jqp
    # Git compatible vcs
    pkgs.jujutsu
    # Git TUI
    pkgs.lazygit
    # Mongodb community edition (for local development)
    pkgs.mongodb-ce
    # Mongodb cli interface
    pkgs.mongosh
    # Better Vim
    pkgs.neovim
    # Neovim gui
    pkgs.neovide
    # Nix-dsl formatter
    pkgs.nixfmt-rfc-style
    # Cross platform prompt
    pkgs.oh-my-posh
    # GNU password-store (key manager)
    pkgs.pass
    # Npm but better, faster, stronger...
    pkgs.nodejs_22.pkgs.pnpm
    # Automatic checks before committing
    pkgs.pre-commit
    # Faster grep
    pkgs.ripgrep
    # Rust toolchain
    pkgs.rustup
    # Easy symlinks for dotfiles
    pkgs.stow
    # Libsql, better sqlite
    # NOTE: sqld is libsql including some extras
    sqld_pkgs.sqld
    # Turso cli
    pkgs.turso-cli
    # Cli file manager
    pkgs.yazi
    # Terminal multiplexer, required for ghostty since its keybinding functionality as well as tabs sucks
    pkgs.zellij
    # Better cd
    pkgs.zoxide

    # === WORK ===
    pkgs.nodejs_22

    # Pinned version of go for work
    # TODO: Experiment with direnv
    pkgs.go_1_23

    # Used for work
    pkgs.nodejs_22.pkgs.yarn

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    # ".zshrc".source = ~/dotfiles/zsh/.zshrc;
    # ".config/wezterm".source = ~/dotfiles/wezterm;
    # ".config/skhd".source = ~/dotfiles/skhd;
    # ".config/nvim".source = ~/dotfiles/nvim;
    # ".config/nix".source = ~/dotfiles/nix;
    # ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.zsh = {
    # REVIEW: I probably don't want to manage zsh through nix?
    enable = false;
    # but I do want a .zshenv in $HOME defining my $ZDOTDIR, this has no effect when it isn't managed though
    # it would be nice to replace stow with nix, I do want my config files to still be mutable through which may
    # be fundamentally incompatible with nix?
    dotDir = ".config/zsh";
    # Home manager stand alone install requires sourcing this
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      source
    '';
  };
}

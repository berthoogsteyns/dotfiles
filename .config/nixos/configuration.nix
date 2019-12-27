# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball url));
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.plymouth.enable = false;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = { "fs.inotify.max_user_watches" = 524288;};
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuVerbatimConfig = 
  '' 
    namespaces = []
    user="gandalf"
    groups="libvirtd"
  '';

  virtualisation.libvirtd.extraConfig = ''
    unix_sock_group = "libvirt"
    unix_sock_rw_perms = "0770"
    ebtables = "/home/gandalf/.nix-profile/bin/ebtablesd"
  '';
  virtualisation.docker.enable = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
  
  boot.initrd.luks.devices = [
    {
      name = "home";
      device = "/dev/vg_system/home"; 
      preLVM = false;
    }
  ];
 
 fileSystems."/home" = {

   device = "/dev/mapper/home"; # UUID for /dev/mapper/crypted-data
   fsType = "ext4";
  };
  networking.nameservers = [ "1.1.1.1" "1.0.0.1"];
  networking.hostName = "nixos_gandalf"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.adb.enable = true; 
  programs.light.enable = true;
  services.flatpak.enable = true;
  programs.java.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
  '';


  programs.zsh = {
    
    enable = true;

    syntaxHighlighting.enable = true;

    autosuggestions.enable = true;

    enableCompletion = true;

    ohMyZsh = {

      enable = true;

      plugins = [ "git" "sudo" "docker" "fzf"];
       
      customPkgs = [pkgs.starship];
       

    };

  };

  nixpkgs.overlays = [ waylandOverlay ];
  programs.sway.enable = true;
  
  programs.sway.extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export BEMENU_BACKEND=wayland
      export MOZ_ENABLE_WAYLAND=1
      export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
    '';

  programs.sway.extraPackages = with pkgs; [
     swaybg
     swayidle
     swaylock
     grim
     slurp
     mako
     oguri
     kanshi
     redshift-wayland
     xdg-desktop-portal-wlr
     rofi
     wl-clipboard
     gebaar-libinput
     i3status-rust
     wofi
     waybar
  ];

  environment.systemPackages = with pkgs; [
    wget
    neovim
    xwayland
    dmenu
    zsh
    htop
    firefox-wayland
    alacritty 
    curl
    bat
    keepass
    vlc
    qt5.qtwayland
    python3
    vscode
    nox
    virtmanager
    safeeyes
    gitkraken
    xdg_utils
    qbittorrent
    pavucontrol
    lsd
    home-manager
    starship
    gitkraken
    direnv
    dotnet-sdk
    mono
    msbuild
    php74Packages.composer
    php74
    nnn
    gnome3.nautilus
    clipman
    xclip
    fzf
    podman
    postman
    rsync
    firefox-devedition-bin-unwrapped
  ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      inconsolata
      terminus_font
      proggyfonts
      dejavu_fonts
      font-awesome-ttf
      font-awesome
      ubuntu_font_family
      source-code-pro
      source-sans-pro
      source-serif-pro
      monoid
      fira-code
      hasklig
    ];
  };
  # xdg.portal.enable = true;
  # xdg.portal.gtkUsePortal = true;
  xdg.portal = {
    
    enable = true;

    gtkUsePortal = true;

    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
  nixpkgs.config.allowUnfree = true;
  powerManagement.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.tor = {
    enable = true;

    client.enable = true;
  };
  # services.tlp.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprintBin canon-cups-ufr2 cnijfilter2];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {

    enable = true;
    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
    

  };
  hardware.bluetooth = {
    enable = true;

  };

  hardware.opengl.enable = true;
  services.upower.enable = true;
  

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  #services.xserver.layout = "us";
  #services.xserver.xkbOptions = "eurosign:e";

  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.displayManager.gdm.wayland = true;
  #services.xserver.desktopManager.gnome3.enable = true;

  ## Enable touchpad support.
  #services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
 users.users.gandalf = {
   isNormalUser = true;
   extraGroups = [ "wheel" "sway" "video" "audio" "input" "libvirtd" "adbusers" "docker" "vboxusers"]; # Enable ‘sudo’ for the user.
   shell = pkgs.zsh;
   packages = with pkgs; [
      git vim mutt spectacle htop
      wget tmux htop git ripgrep unzip
      openssh
      # TODO: Remove xwayland, for sanity
      xwayland dmenu
      firefox-wayland 
      qt5.qtwayland
   ];
 };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

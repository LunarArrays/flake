{ config, pkgs, inputs,  ... }:
{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/packages.nix
	  ./disko-config.nix
		#./nvidia.com
	  inputs.disko.nixosModules.default
    ];

  nix.extraOptions = ''
  experimental-features = nix-command flakes
  '';
  nix.package = pkgs.nixVersions.latest;

    boot.binfmt.emulatedSystems = ["i686-linux" "aarch64-linux"];
    nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  boot.loader = {
	grub.device = "nodev";
	grub.efiSupport = true;
	efi.canTouchEfiVariables = true;
  };

  virtualisation.docker.enable = true;

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "en";
  };

services.greetd = {
  enable = true;
  settings = rec {
    initial_session = {
      command = "${pkgs.hyprland}/bin/Hyprland";
      user = "user";
    };
    default_session = initial_session;
  };
};
  #services.xserver.videoDrivers = ["AMD"];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
	jack.enable = true;
  };
  services.pipewire.wireplumber.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "networkmanager"]; # Enable ‘sudo’ for the user.
  };

virtualisation.libvirtd.enable = true;
programs.dconf.enable = true;

	programs.git = {
		enable = true;
		lfs.enable = true;
	};

  environment.systemPackages = with pkgs; [
    wget
	libgcc
    jdk8
    unzip
    pciutils
    jq
    socat
    rustc
    gcc
    cargo
    rustup
    python312
    gtk3
    luajitPackages.luarocks
    pkg-config
	ninja
    networkmanager
  ];
  #wiered fixed 
  #---------DO NOT MESS WITH-----------
  boot.swraid.enable = false;
	boot.tmp.useTmpfs = false;
  nix.optimise.automatic = true;

  system.stateVersion = "23.11"; # Did you read the comment?

}


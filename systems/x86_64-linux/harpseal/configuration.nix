{ config, pkgs, inputs,  ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/packages.nix
	  ./disko-config.nix
	  inputs.disko.nixosModules.default
    ];

  nix.extraOptions = ''
  experimental-features = nix-command flakes
  '';
  nix.package = pkgs.nixVersions.latest;

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
    keyMap = "de";
  };

services.monado = {
  enable = true;
  defaultRuntime = true; # Register as default OpenXR runtime
};

boot.kernelPatches = [
  {
    name = "amdgpu-ignore-ctx-privileges";
    patch = pkgs.fetchpatch {
      name = "cap_sys_nice_begone.patch";
      url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
      hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
    };
  }
];


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
  services.xserver.videoDrivers = ["AMD"];

  sound.enable = true;


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

  environment.systemPackages = with pkgs; [
    wget
	libgcc
    git
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
  nix.optimise.automatic = true;

  system.stateVersion = "23.11"; # Did you read the comment?

}


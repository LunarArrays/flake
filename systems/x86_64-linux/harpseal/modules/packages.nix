{config, pkgs,inputs, system, ...}: {

users.users.user.shell = pkgs.fish;
programs.fish.enable = true;

programs.steam.enable = true;
#programs.neovim.enable = true;
programs.hyprland.enable = true;
users.users.user.packages = with pkgs; [
#------Essential----
usbutils
kitty
librewolf
pkg-config
pamixer

ccid
pcsclite
river
ripgrep # needed for nvim telescope to work
gammastep
river

#------Estetics---------
swww
eww
nordic
microserver
papirus-icon-theme
bibata-cursors
inotify-tools
sassc
papirus-nord
pwvucontrol
#------Lsp Server & other Progrming stuff-------
qmk
rust-analyzer
ccls
lua-language-server
nil

meson

arduino-ide
arduino

#------Programms-----
bottles

jameica
pcsc-cyberjack
keepassxc
libreoffice
blockbench

thunderbird

kmymoney
keepassxc

pulsemixer
gimp
obs-studio

signal-desktop
dolphin
logseq

grim
slurp

brave
libsForQt5.kdeconnect-kde

#---------Fun----------
prismlauncher
yt-dlp
ani-cli

#-------Music--------
mpd
ncmpcpp
mpv
ffmpeg

playerctl
mpdris2

ardour
reaper
#--------Wine---------
	wine
    winetricks
    wineWowPackages.waylandFull

	gamemode

#-------tui tool--------
ani-cli
tree

lsd

android-tools

#------ preparing to move on from nix ): ---------
butane 
podman
];

  fonts = {
	packages = with pkgs; [
	comic-mono
	(nerdfonts.override { fonts = [ "ComicShannsMono" "FiraCode"]; })
	];
	fontconfig = {
    defaultFonts = {
      serif = [ "Vazirmatn" "Ubuntu" ];
      sansSerif = [ "Vazirmatn" "Ubuntu" ];
      monospace = [ "FiraCode" ];
    };
  };
  };

}

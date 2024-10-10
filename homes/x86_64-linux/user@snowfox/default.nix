{ inputs, lib, pkgs, ... }:
with lib;
with lib.arctic; {

arctic = {
	desktop =  {
		hyprland = {
			enable = true;
			wallpaper = "newpaper.png";
		};
		river = {
			enable = true;
			wallpaper = "newpaper.png";
		};
		fuzzle.enable = true;
		dunst.enable = true;
		kitty.enable = true;
		eww.enable = true;
		hyprlock.enable = true;
	};
	cli-apps = {
		fish.enable = true;
		ncmpcpp.enable = true;
		mpd.enable = true;
		nvim.enable = true;
	};
	apps = {
		firefox.enable = true;
	};
};

home = {
  stateVersion = "23.11"; # Please read the comment before changing.
  packages = with pkgs; [
	librewolf
	inputs.neovim.packages.x86_64-linux.default
  ];
  };
  programs.home-manager.enable = true;


}

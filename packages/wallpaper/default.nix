{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
	pname = "wallpaper"; 
	version = "0.1";
	src = ./images;
	dontUnpack = true;
	installPhase = ''
		mkdir -p $out/wallpapers
		cp -r $src/* $out/wallpapers
	'';
}

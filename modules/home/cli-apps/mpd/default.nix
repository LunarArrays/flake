{ config, pkgs,lib, ... }:
with lib;
with lib.arctic; let
	cfg = config.arctic.cli-apps.mpd;
in
{
	options.arctic.cli-apps.mpd = {
		enable = lib.mkEnableOption "Old config"; 
	};
config = lib.mkIf cfg.enable {
	services.mpd = {
		enable = true;
		dataDir = "/home/user/.config/mpd";
		musicDirectory = "~/music";
		network = {
		listenAddress = "127.0.0.1";
		port = 6600;
		startWhenNeeded = true;
		};
		extraConfig = ''
	audio_output {
	type "pulse"
	name "pulse audio"
	}
		'';
	};
};
}


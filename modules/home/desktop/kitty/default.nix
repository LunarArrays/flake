{ config, pkgs, lib, ... }:
let 
  cfg = config.arctic.desktop.kitty;
in {
  options.arctic.desktop.kitty = {
    enable = lib.mkEnableOption "kitty";
  };
	config = lib.mkIf cfg.enable
	{
		programs.kitty = {
			enable = true;
			font.name = "ComicMono";
			theme = "${config.arctic.color.colors.kitty_name}";
			extraConfig = ''
				background_opacity 0.9
				confirm_os_window_close 0
			'';
		};
	};
}

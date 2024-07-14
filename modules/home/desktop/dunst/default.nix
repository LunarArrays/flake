{ config, pkgs,lib, ... }:
with lib;
with lib.arctic; let 
  cfg = config.arctic.desktop.dunst;
in {
  options.arctic.desktop.dunst = {
    enable = lib.mkEnableOption "dunst";
  };
config = lib.mkIf cfg.enable {
	services = {
		dunst = {
			enable = true;
			settings = {
				global = {
					monitor = 1;
					width = 300;
					height = 300;
					offset = "20x20";	
					origin = "top-right";
					transparency = 10;
					corner_radius = 20;
					font = "ComicMono 9";
					dmenu = "${pkgs.fuzzel} --dmenu -p dunst:";
				};

				urgency_normal = {
					background = "#2e3440";
					foreground = "#e5e9f0";
					timeout = 10;
					frame_color = "#81a1c1";
				};
				urgency_critical = {
					background = "#2e3440";
					foreground = "#bf616a";
					timeout = 30;
					frame_color = "#bf616a";
				};
			};
		};
	  };
	};
}


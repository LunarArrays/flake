{ config, pkgs,lib,... }:
with lib;
with lib.arctic; let
	cfg = config.arctic.cli-apps.zellij;
in
{
	options.arctic.cli-apps.zellij = {
		enable = lib.mkEnableOption "zellij"; 
	};


config = lib.mkIf cfg.enable {
	programs.zellij = 
	{
		enable = true;
		enableFishIntegration = true;
		settings = 
		{
			theme = "custom";  
			themes.custom.fg = "#586e75"; 
			themes.custom.bg = "#fdf6e3";
			themes.custom.red = "#dc322f";
			themes.custom.green = "#859900";
			themes.custom.blue = "#268bd2";
			themes.custom.yellow = "#b58900";
			themes.custom.magenta = "#d33682";
			themes.custom.orange = "#cb4b16";
			themes.custom.cyan = "#2aa198";
			themes.custom.black = "#002b36";
			themes.custom.white = "#fdf6e3";
		};
	};
};
}


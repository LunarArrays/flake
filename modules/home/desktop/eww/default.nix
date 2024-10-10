{config, lib, pkgs, ...}:
let
	cfg = config.arctic.desktop.eww;
in
{
	options.arctic.desktop.eww = {
		enable = lib.mkEnableOption "eww"; 
	};

	config = lib.mkIf cfg.enable {
		programs.eww = {
			enable = true;
			configDir = ./eww;
		};

	};
}

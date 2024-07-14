{config, lib, pkgs, ...}:
let
	cfg = config.arctic.cli-apps.nvim;
in
{
	options.arctic.cli-apps.nvim = {
		enable = lib.mkEnableOption "neovim"; 
	};

	config = lib.mkIf cfg.enable {
		programs = {
			neovim.enable = true;
		};
	};
}

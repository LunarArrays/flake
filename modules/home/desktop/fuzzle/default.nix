{namespace, config, lib, ...}:
let
	cfg = config.${namespace}.desktop.fuzzle;
in
{
	options.${namespace}.desktop.fuzzle = {
		enable = lib.mkEnableOption "fuzzle"; 
	};

	config = lib.mkIf cfg.enable {
		programs.fuzzel = {
			enable = true;
			settings = {
				colors = {
					background    = "${lib.toLower config.arctic.color.colors.b1}f5";
					selection     = "${lib.toLower config.arctic.color.colors.bF}f5";
					border        = "${lib.toLower config.arctic.color.colors.b8}f5";
					selection-text= "${lib.toLower config.arctic.color.colors.b6}f5";
				};
				border = {
					width  = 2;
					radius = 15;
				};
				main = {
					font = "ComicMono";
				};
			};
		};
	};
}

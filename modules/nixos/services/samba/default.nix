{namespace, config, lib, ...}:
let
	cfg = config.${namespace}.desktop.fuzzle;
in
{
	options.${namespace}.service = {
		enable = lib.mkEnableOption "samba"; 
	};

	config = lib.mkIf cfg.enable {
		service.samba = {
			enable = true;

		};
	};
}

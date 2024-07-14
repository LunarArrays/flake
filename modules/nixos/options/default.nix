{lib, config, ...}:
let 
	inherit (lib) types mkIf mkDefault mkMerge mkOption;
	cfg = config.arctic;
  in
{
	options.arctic = {
		    programs.window_manager = mkOption {type = types.str; default = ""; description = "";};
  };

  config =(mkMerge [
    {
      assertions = [
        {
          assertion = cfg.programs.window_manager != null;
          message = "arctic.user.name must be set";
        }
      ];
    }
  ]);

}

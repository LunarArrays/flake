{
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  rose-pine = {
	name = "nord";
	kitty_name = "Nord";
	b0 = "2E3440"; #bg
	b1 = "3B4252"; #light bg
	b2 = "434C5E"; #even lighter bg /selection bg 
	b3 = "4C566A"; # comments
	b4 = "D8DEE9"; # dark fg
	b5 = "E5E9F0"; # fg 
	b6 = "ECEFF4"; # light fg
	b7 = "8FBCBB"; # light bg
	b8 = "88C0D0"; # vars
	b9 = "81A1C1"; # types
	bA = "5E81AC"; # classes
	bB = "BF616A"; # strings
	bC = "D08770"; # regex
	bD = "EBCB8B"; # functions, headings
	bE = "A3BE8C"; # keywords
	bF = "B48EAD"; # nothing lol (deprecated)
	};
in {
  options.arctic.color = {
    colors = mkOption {type = types.attrsOf types.str; default = rose-pine; description = "The user's prefered color theme.";};
    name = mkOption {type = types.str; default = "Nord"; description = "The name of the user's prefered color theme.";};
  };
}

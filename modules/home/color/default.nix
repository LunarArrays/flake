{
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  nord = {
	name = "Nord";
	b0 = "2E3440"; #bg
	b1 = "3B4252"; #light bg
	b2 = "434C5E"; #even lighter bg /selection bg 
	b3 = "4C566A"; # comments
	b4 = "D8DEE9"; # dark fg
	b5 = "E5E9F0"; # fg 
	b6 = "ECEFF4"; # light fg
	b7 = "8FBCBB"; # light bg
	b8 = "BF616A"; # vars
	b9 = "D08770"; # types
	bA = "EBCB8B"; # classes
	bB = "A3BE8C"; # strings
	bC = "88C0D0"; # regex
	bD = "81A1C1"; # functions, headings
	bE = "B48EAD"; # keywords
	bF = "5E81AC"; # nothing lol (deprecated)
	};
in {
  options.arctic.color = {
    colors = mkOption {type = types.attrsOf types.str; default = nord; description = "The user's prefered color theme.";};
    name = mkOption {type = types.str; default = "Nord"; description = "The name of the user's prefered color theme.";};
  };
}

{config, lib, pkgs, inputs, ...}:
let
	cfg = config.arctic.apps.firefox;
in
{
	imports = [ ./arkenfox.nix];
	options.arctic.apps.firefox = {
		enable = lib.mkEnableOption "firefox"; 
	};

	config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = {
			"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
			"widget.gtk.ignore-bogus-leave-notify" = "1";
            "browser.search.defaultenginename" = "DuckDuckGo";
            "browser.search.order.1" = "DuckDuckGo";
          };
          search = {
            force = true;
            default = "DuckDuckGo";
            order = [ "DuckDuckGo" "Google" ];
            engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "NixOS Wiki" = {
                urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };
              "Searx" = {
                urls = [{ template = "https://searx.aicampground.com/?q={searchTerms}"; }];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@searx" ];
              };
              "Bing".metaData.hidden = true;
              "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            };
          };
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin   
            darkreader      
			sidebery
			kristofferhagen-nord-theme
			new-tab-override
			keepassxc-browser
			sponsorblock
			dearrow
          ];                
		#user chrome by Shina-SG repo: https://github.com/Shina-SG/Shina-Fox 
		  userChrome = (builtins.readFile ./userChrome.css);
        };
      };
    };
	};
}

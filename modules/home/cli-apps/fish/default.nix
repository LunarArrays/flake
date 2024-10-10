{config, lib, pkgs,inputs, system,  ...}:
let
	cfg = config.arctic.cli-apps.fish;
in
{
	options.arctic.cli-apps.fish = {
		enable = lib.mkEnableOption "fish"; 
	};

	config = lib.mkIf cfg.enable {
		programs = {
			 fish = {
				enable = true;
				shellInit = "set fish_greeting \n ${pkgs.arctic.nekofetch}/bin/nekofetch";
				shellAliases = {
					bt-c = " bluetoothctl connect 2C:FD:B3:82:89:0B";
					bt-r = " bluetoothctl disconnect 2C:FD:B3:82:89:0B && bluetoothctl connect 2C:FD:B3:82:89:0B";
					yt-mu = "yt-dlp -f 'ba' -x --audio-format mp3 --embed-thumbnail --embed-metadata --restrict-filenames -o '%(title)s.%(ext)s' --replace-in-metadata 'title' '[a-zA-Z0-9]+ - ' '' --split-chapters -P '~/music' --parse-metadata 'album:%(playlist_title)s' --output-na-placeholder ''";
					yt-mu-chap = "yt-dlp -P '~/music' -f 'ba' -x --audio-format mp3 --embed-thumbnail --embed-metadata  --split-chapters --restrict-filenames -o '%(section_title)s.%(ext)s' --output-na-placeholder '' --replace-in-metadata 'title' '[a-zA-Z0-9]+ - ' '' --parse-metadata 'album:%(section_title)s' --parse-metadata 'album:%(chapter)s'";
					grep = "rg";
					ls = "lsd";
					mvim = "${inputs.neovim.packages.${system}.default}/bin/nvim";
				};
			};

			starship = {
				enable=true;
			};

			atuin.enable = true;
			direnv = {
				enable = true;
				nix-direnv.enable = true;
			};

		};
	};
}

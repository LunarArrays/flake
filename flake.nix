{
inputs = {
	nixpkgs.url = "nixpkgs/nixos-unstable";
	home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	hyprland = {
		url = "github:hyprwm/Hyprland";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	disko = {
		url = "github:nix-community/disko";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	fu = {
		url = "github:numtide/flake-utils";
		inputs.nixpkgs.follows = "nixpkgs";
	};
	snowfall-lib = {
		url = "github:snowfallorg/lib";
		inputs.nixpkgs.follows = "nixpkgs";
	};
	nur = {
		url = "github:nix-community/nur";
	    inputs.nixpkgs.follows = "nixpkgs";
	};
	neovim = {
		url = "github:LunarArrays/nvim";
		inputs.nixpkgs.follows = "nixpkgs";
		};
};

outputs = inputs:
let 
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
		snowfall = {
			namespace = "arctic";
			meta = {
                name = "acrtic_config";
                title = "Arctic Config";
			};
		};
      };
in
	lib.mkFlake{
		channels-config = {
			allowUnfree = true;
			permittedInsecurePackages = [
				"electron-28.3.3"
				"electron-27.3.11"
			];
		};
		overlays = with inputs; [ nur.overlay];
		
	};
}

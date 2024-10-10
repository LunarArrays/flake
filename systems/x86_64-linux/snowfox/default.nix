{
    lib,
    pkgs,
    inputs,
    config,
	system,
	namespace,
    ...
}:
with lib;
with lib.arctic;{
	imports = [
	./configuration.nix
	];
		environment.systemPackages = with pkgs.arctic; [
			nekofetch
			rmpc
			nord_bar
			wallpaper
			inputs.neovim.packages.${system}.default
		];
	${namespace} = 
	{
		vm.enable = true;		
	};
  system.stateVersion = "23.11"; # Did you read the comment?
}

{config, namespace, lib, ... }:
with lib;
with lib.${namespace}; let 
	cfg = config.${namespace}.vm;
in
{
	options.${namespace}.vm = {
		enable = lib.mkEnableOption "virt-manager";
	};
	config = lib.mkIf cfg.enable {
		virtualisation.libvirtd.enable = true;
		programs.virt-manager.enable = true;
	};
}

{lib, rustPlatform, gtk4, gtk4-layer-shell, pkg-config, librsvg}:
rustPlatform.buildRustPackage {
	pname = "nord_bar";
	version = "0.1";
	cargoLock.lockFile = ./Cargo.lock;
	src = lib.cleanSource ./.;  
	cargoBuildFlags = [ "--bin" "nord_bar" ];
	cargoTestFlags = [ "--bin" "nord_bar" ];
	nativeBuildInputs = [ pkg-config ];
	buildInputs = [ gtk4 librsvg gtk4-layer-shell];
	meta = {
		description = "my custom top bar";
		license = lib.licenses.mit; #if I publish it lol
	};
}

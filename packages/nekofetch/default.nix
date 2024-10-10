{lib, rustPlatform}:
rustPlatform.buildRustPackage {
  pname = "nekofetch";
  version = "0.1";

  cargoLock.lockFile = ./Cargo.lock;

  src = lib.cleanSource ./.;

  meta = {
	    description = "a badly writen neofetch clone";
  };
}

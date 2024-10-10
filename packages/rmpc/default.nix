{lib, rustPlatform}:
rustPlatform.buildRustPackage {
  pname = "rmpc";
  version = "0.1";

  cargoLock.lockFile = ./Cargo.lock;

  src = lib.cleanSource ./.;

  meta = {
	    description = "a badly writen mpd cli for nord_bar (tui mmode soon)";
  };
}

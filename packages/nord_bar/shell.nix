{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [
	gtk4.dev 
	gtk4-layer-shell.dev 
	gdk-pixbuf.dev 
	cairo.dev 
	libglibutil.dev 
	atkmm.dev 
	glibmm.dev 
	pango.dev
	pkg-config
	papirus-icon-theme
	];
}


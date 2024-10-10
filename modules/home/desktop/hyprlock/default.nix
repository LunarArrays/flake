{config, lib, ...}: 

let
  c = config.arctic.color.colors;

  font_family = "Comic Mono";
in 
{
options.arctic.desktop.hyprlock =
{
	enable = lib.mkEnableOption "hyprlock";
};

config = lib.mkIf config.arctic.desktop.hyprlock.enable {
  programs.hyprlock = {
    enable = true;
	settings = {

    general = {
      disable_loading_bar = true;
      hide_cursor = false;
      no_fade_in = true;
    };

    input-fields = [
      {
        monitor = "eDP-1";

        size = {
          width = 180;
          height = 20;
        };

        outline_thickness = 2;

        outer_color = "rgb(${c.b0})";
        inner_color = "rgb(${c.b1})";
        font_color = "rgb(${c.b1})";

        fade_on_empty = false;
        placeholder_text = ''<span font_family="${font_family}" foreground="##${c.b1}">Password...</span>'';

        dots_spacing = 0.3;
        dots_center = true;
      }
    ];

    labels = [
    ];
  };
  };
  };
}

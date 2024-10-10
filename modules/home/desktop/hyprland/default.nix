 {config, pkgs, lib, ... }:

with lib;
with lib.arctic; let
	inherit (lib) types mkOption;
	cfg = config.arctic.desktop.hyprland;
in
{
	options.arctic.desktop.hyprland = {
		enable = mkEnableOption "hyprland"; 
		wallpaper = mkOption {
			type = with types; str;
			description = "what wallpaper out of the images package to use";
		};
	};


config = mkIf cfg.enable {
	gtk = {
		enable = true;
		cursorTheme = {
			package = pkgs.bibata-cursors;
			name = "Bibata-Modern-Ice";
			size = 24;
		};
	};
	wayland.windowManager.hyprland ={
	enable = true;
	extraConfig = ''
	monitor=,preferred,auto,auto

	monitor=DP-1, 2560x1440@143.973007,1080x356,1
	monitor = DP-1, addreserved, 25, 0, 0, 0
	monitor=HDMI-A-1, 1920x1080, 0x0,1

	monitor=HDMI-A-1,transform,1

	# XDG
	env = XDG_CURRENT_DESKTOP,Hyprland
	env = XDG_SESSION_TYPE,wayland
	env = XDG_SESSION_DESKTOP,Hyprland

	# QT
	env = QT_AUTO_SCREEN_SCALE_FACTOR,1
	env = QT_QPA_PLATFORM=wayland;xcb    # Not yet working for onlyoffice-editor
	env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
	env = QT_QPA_PLATFORMTHEME,qt6ct

	# Toolkit
	env = SDL_VIDEODRIVER,wayland
	env = _JAVA_AWT_WM_NONEREPARENTING,1
	env = CLUTTER_BACKEND,wayland
	env = GDK_BACKEND,wayland,x11
	
	env = XDG_SESSION_TYPE,wayland
	env = WLR_NO_HARDWARE_CURSORS,1

	env = XCURSOR_SIZE,24

	exec-once = swww-daemon && swww img ${pkgs.arctic.wallpaper}/wallpapers/${cfg.wallpaper}
	exec-once = ${pkgs.arctic.nord_bar}/bin/nord_bar &
	exec-once = hyprctl setcursor Bibata-Modern-Ice 24


	# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
	input {
		follow_mouse = 1

		touchpad {
			natural_scroll = false
		}

			sensitivity = -1 # -1.0 - 1.0, 0 means no modification.
	}

	general {
		# See https://wiki.hyprland.org/Configuring/Variables/ for more

		gaps_in = 5
		gaps_out = 20
		border_size = 2
		col.active_border = rgb(${config.arctic.color.colors.b8})
		col.inactive_border = rgb(${config.arctic.color.colors.b1})

		layout = dwindle
	}

	decoration {
		# See https://wiki.hyprland.org/Configuring/Variables/ for more

		rounding = 15

		blur {
					enabled = true
		   xray = true
			special = false
			new_optimizations = on

			size = 5
			passes = 4
			brightness = 1
			noise = 0.01
			contrast = 1

			#vibrancy = 0.1
			#vibrancy_darkness = 0

		}
	}

	animations {
		enabled = true

		# Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
		bezier=overshot,0.13,0.99,0.29,1.1
		animation=windows,1,4,overshot,slide
		animation=fade,1,10,default
		animation=workspaces,1,8.8,overshot,slide
		animation=border,1,14,default
	}

	dwindle {
		# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
		pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
		preserve_split = true # you probably want this
	}

	gestures {
		# See https://wiki.hyprland.org/Configuring/Variables/ for more
		workspace_swipe = false
	}

	# Example per-device config
	# See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
	# Example windowrule v1
	# windowrule = float, ^(kitty)$
	# Example windowrule v2
	# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
	windowrule=animation popin,fuzzel
	# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


	# See https://wiki.hyprland.org/Configuring/Keywords/ for more
	$mainMod = SUPER

	# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
	bind = $mainMod, Q, exec, kitty
	bind = $mainMod, F, exec, firefox
	bind = $mainMod, M, exec, prismlauncher 
	bind = $mainMod, C, killactive,
	bind = $mainMod, K, exit,
	bind = $mainMod, N, exec, nemo
	bind = $mainMod, V, togglefloating,
	bind = $mainMod, R, exec, fuzzel
	bind = $mainMod, P, pseudo, # dwindle
	bind = $mainMod, J, togglesplit, # dwindle

	# Move focus with mainMod + arrow keys
	bind = $mainMod, left, movefocus, l
	bind = $mainMod, right, movefocus, r
	bind = $mainMod, up, movefocus, u
	bind = $mainMod, down, movefocus, d

	# Switch workspaces with mainMod + [0-9]
	bind = $mainMod, 1, workspace, 1
	bind = $mainMod, 2, workspace, 2
	bind = $mainMod, 3, workspace, 3
	bind = $mainMod, 4, workspace, 4
	bind = $mainMod, 5, workspace, 5
	bind = $mainMod, 6, workspace, 6
	bind = $mainMod, 7, workspace, 7
	bind = $mainMod, 8, workspace, 8
	bind = $mainMod, 9, workspace, 9
	bind = $mainMod, 0, workspace, 10

	# Move active window to a workspace with mainMod + SHIFT + [0-9]
	bind = $mainMod SHIFT, 1, movetoworkspace, 1
	bind = $mainMod SHIFT, 2, movetoworkspace, 2
	bind = $mainMod SHIFT, 3, movetoworkspace, 3
	bind = $mainMod SHIFT, 4, movetoworkspace, 4
	bind = $mainMod SHIFT, 5, movetoworkspace, 5
	bind = $mainMod SHIFT, 6, movetoworkspace, 6
	bind = $mainMod SHIFT, 7, movetoworkspace, 7
	bind = $mainMod SHIFT, 8, movetoworkspace, 8
	bind = $mainMod SHIFT, 9, movetoworkspace, 9
	bind = $mainMod SHIFT, 0, movetoworkspace, 10

	# Scroll through existing workspaces with mainMod + scroll
	bind = $mainMod, mouse_down, workspace, e+1
	bind = $mainMod, mouse_up, workspace, e-1

	# Move/resize windows with mainMod + LMB/RMB and dragging
	bindm = $mainMod, mouse:272, movewindow
	bindm = $mainMod, mouse:273, resizewindow
		'';
	};
};
}

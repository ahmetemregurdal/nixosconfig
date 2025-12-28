{config, lib, pkgs, osConfig, inputs, ...}:

let
	cfg = config.userSettings.niri;
	font = config.stylix.fonts.monospace.name;
	term = config.userSettings.terminal;
	spawnTerm = config.userSettings.spawnTerminal;
	spawnBrowser = config.userSettings.spawnBrowser;
	spawnEditor = config.userSettings.spawnEditor;
in
{
	options = {
		userSettings.niri = {
			enable = lib.mkOption {
				default = osConfig.systemSettings.niri.enable;
				type = lib.types.bool;
				description = "Enable Niri HomeManager";
			};
		};
	};

	config = lib.mkIf cfg.enable {
		userSettings.stylix.enable = true;
		home.sessionVariables = {
			XDG_CURRENT_DESKTOP = "Niri";
			NIXOS_OZONE_WL = "1";
			ELECTRON_OZONE_PLATFORM_HINT = "auto";
			XDG_SESSION_TYPE = "wayland";
		};

		programs.niri = {
			settings = {
				binds = with config.lib.niri.actions; {
					"Mod+T".action = spawn term;
					"Mod+D".action = spawn "fuzzel";
					"Mod+B".action = spawn-sh spawnBrowser;
					"Mod+E".action = spawn-sh spawnEditor;
					"XF86AudioRaiseVolume".action = spawn-sh "exec swayosd-client --output-volume=raise";
					"XF86AudioLowerVolume".action = spawn-sh "exec swayosd-client --output-volume=lower";
					"XF86AudioMute".action = spawn-sh "exec swayosd-client --output-volume=mute-toggle";
					"XF86AudioMicMute".action = spawn-sh "exec swayosd-client --input-volume=mute-toggle";
					"XF86MonBrightnessUp".action = spawn-sh "exec swayosd-client --brightness=raise";
					"XF86MonBrightnessDown".action = spawn-sh "exec swayosd-client --brightness=lower";
					"XF86AudioPlay".action = spawn-sh "exec playerctl play-pause";
					"XF86AudioStop".action = spawn-sh "exec playerctl stop";
					"XF86AudioNext".action = spawn-sh "exec playerctl next";
					"XF86AudioPrev".action = spawn-sh "exec playerctl previous";
					"XF86Calculator".action = spawn-sh "exec qalculate-qt";
					"Mod+Shift+E".action = quit { skip-confirmation = true;};
					"Mod+O".action = toggle-overview;
					"Mod+Shift+F".action = fullscreen-window;
					"Mod+F".action = maximize-column;
					"Mod+Q".action = close-window;
					"Mod+H".action = focus-column-left;
					"Mod+L".action = focus-column-right;
					"Mod+Ctrl+H".action = move-column-left;
					"Mod+Ctrl+L".action = move-column-right;
					"Mod+J".action = focus-window-or-workspace-down;
					"Mod+K".action = focus-window-or-workspace-up;
					"Mod+Ctrl+J".action = move-window-down-or-to-workspace-down;
					"Mod+Ctrl+K".action = move-window-up-or-to-workspace-up;
					"Mod+BracketLeft".action = consume-or-expel-window-left;
					"Mod+BracketRight".action = consume-or-expel-window-right;
					"Mod+W".action = toggle-column-tabbed-display;
					"Mod+C".action = center-column;
					"Mod+Shift+C".action = center-visible-columns;
					"Mod+R".action = switch-preset-column-width;
					"Mod+Space".action = switch-layout "next";
					"Print".action = spawn-sh "exec grim -g \"$(slurp -d -F ${config.stylix.fonts.monospace.name})\" \"${config.xdg.userDirs.extraConfig.XDG_SCREENSHOT_DIR}/$(date +'%Y-%m-%d %H:%M:%S.png')\"";
				};
				prefer-no-csd = true;
				spawn-at-startup = [
					{ argv = [ "xwayland-satellite" ]; }
				];
				layout = {
					gaps = 10;
					preset-column-widths = [
						{ proportion = 1. / 3.;}
						{ proportion = 1. / 2.;}
						{ proportion = 2. / 3.;}
					];
					default-column-width = { proportion = 1. / 1.;};
					default-column-display = "tabbed";
					tab-indicator = {
						hide-when-single-tab = true;
					};
					center-focused-column = "on-overflow";
					always-center-single-column = true;
				};

				input = {
					keyboard = {
						xkb = {
							layout = "us,tr";
						};
					};
					touchpad = {
						tap = true;
						natural-scroll = true;
						drag-lock = true;
					};
					warp-mouse-to-focus = {
						enable = true;
						mode = "center-xy";
					};
					focus-follows-mouse = {
						enable = true;
						max-scroll-amount = "90%";
					};
				};
				cursor = {
					hide-when-typing = true;
					hide-after-inactive-ms = 1000;
				};
				overview = {
					zoom = 1. / 2.;
					backdrop-color = "#" + config.lib.stylix.colors.base01;
				};
				hotkey-overlay = {
					skip-at-startup = true;
				};
			};
		};
		stylix.targets.niri.enable = true;
		stylix.targets.fuzzel.enable = true;
		services.wpaperd.enable = true;
		stylix.targets.wpaperd.enable = true;
		programs.fuzzel = {
			enable = true;
			settings = {
				main = {
					font = lib.mkForce (font + ":size=20");
					show-actions = true;
					terminal = spawnTerm;
				};
			};
		};

		stylix.targets.waybar.enable = true;
		programs.waybar = {
			enable = true;
			settings = {
				mainBar = {
					layer = "top";
					position = "top";
					height = 30;
					modules-left = [ "niri/workspaces" ];
					modules-center = [ "niri/window" ];
					modules-right = [ "niri/language" "backlight" "wireplumber" "battery" "clock" ];

					clock = {
						timezone = "Europe/Istanbul";
						interval = 60;
						format = " {:%H:%M}";
						tooltip-format = "<tt><small>{calendar}</small></tt>";
						calendar = {
							mode = "year";
							mode-mon-col = 3;
							weeks-pos = "right";
							on-scroll = 1;
							format = {
								months = "<span color='#" + config.lib.stylix.colors.base06 + "'><b>{}</b></span>";
								days = "<span color='#" + config.lib.stylix.colors.base0E + "'><b>{}</b></span>";
								weeks = "<span color='#" + config.lib.stylix.colors.base0D + "'><b>W{}</b></span>";
								weekdays = "<span color='#" + config.lib.stylix.colors.base0A + "'><b>{}</b></span>";
								today = "<span color='#" + config.lib.stylix.colors.base08 + "'><b><u>{}</u></b></span>";
							};
						};
					};

					"niri/language" = {
						format = " {}";
						format-en = "US";
						format-tr = "TR";
					};

					"niri/window" = {
						format = "{title}";
						icon = true;
						icon-size = 16;
					};

					mpris = {
						format = "{artist} {album} - {title} {position}/{length}";
					};

					backlight = {
						format = "{icon} {percent}%";
						format-icons = [ "󰃜" "󰃛" "󰃚" "󰃞" "󰃝" "󰃟" "󰃠" ];
						tooltip = false;
					};

					wireplumber = {
						format = "{icon} {volume}%";
						format-muted = " ";
						tooltip = false;
						format-icons = [ "" "" "" ];
					};

					battery = {
						format = "{icon} {capacity}%";
						format-icons = [ "" "" "" "" "" ];
					};
				};
			};

			systemd.enable = true;
		};

		services.swayosd = {
			enable = true;
			topMargin = 0.9;
		};
		home.packages = with pkgs; [
			wl-clipboard
			slurp
			grim
			playerctl
		];

		services.wl-clip-persist = {
			enable = true;
		};

		stylix.targets.fnott.enable = true;
		services.fnott = {
			enable = true;
		};
	};
}

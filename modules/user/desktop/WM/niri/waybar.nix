{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.niri;
	font = config.stylix.fonts.monospace.name;
	colors = config.lib.stylix.colors;
	waybarCss = pkgs.replaceVars ./waybar.css {
		fontName = font;
		base00 = colors.base00;
		base05 = colors.base05;
		base09 = colors.base09;
		base0A = colors.base0A;
		base0B = colors.base0B;
		base0C = colors.base0C;
		base0D = colors.base0D;
		base0E = colors.base0E;
		base0F = colors.base0F;
	};
in
{
	config = lib.mkIf cfg.enable {
		programs.waybar = {
			enable = true;
			style = waybarCss;
			settings = {
				mainBar = {
					layer = "top";
					position = "top";
					height = 20;
					modules-left = [
						"mpd"
					];
					modules-center = [ ];
					modules-right = [
						"niri/language"
						"custom/seperator"
						"backlight"
						"custom/seperator"
						"wireplumber"
						"custom/seperator"
						"battery"
						"custom/seperator"
						"cpu"
						"custom/seperator"
						"memory"
						"custom/seperator"
						"clock"
					];

					"custom/seperator" = {
						format = "|";
						interval = "once";
						tooltip = false;
					};

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
								months = "<span color='#" + colors.base06 + "'><b>{}</b></span>";
								days = "<span color='#" + colors.base0E + "'><b>{}</b></span>";
								weeks = "<span color='#" + colors.base0D + "'><b>W{}</b></span>";
								weekdays = "<span color='#" + colors.base0A + "'><b>{}</b></span>";
								today = "<span color='#" + colors.base08 + "'><b><u>{}</u></b></span>";
							};
						};
					};

					"niri/language" = {
						format = " {}";
						format-en = "US";
						format-tr = "TR";
					};

					cpu = {
						interval = 1;
						format = " {avg_frequency:0.1f}Ghz {usage}%";
						tooltip = false;
					};

					memory = {
						interval = 1;
						format = " {used:0.1f}/{total:0.1f}GiB";
						tooltip = false;
					};

					mpd = {
						interval = 5;
						format = "{artist} - {album} - {title} [{elapsedTime:%M:%S}/{totalTime:%M:%S}]";
						tooltip = false;
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
	};
}

{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.niri;
	font = config.stylix.fonts.monospace.name;
	colors = config.lib.stylix.colors;
in
{
	config = lib.mkIf cfg.enable {
		programs.waybar = {
			enable = true;
			style = ''
				* {
					font-family: ${font};
					font-size: 12pt;
					border: none;
					min-height: 0;
					border-radius: 0;
				}
				window#waybar {
					color: #${colors.base05};
					background: #${colors.base00};
				}
				tooltip {
					border: 1px solid #${colors.base0D};
					background: #${colors.base00};
				}
				tooltip label {
					color: #${colors.base05};
				}
				#clock, #backlight, #battery, #cpu, #wireplumber, #language, #memory, #keyboard-state {
					padding: 0 5px;
				}
				#language {
					color: #${colors.base09};
				}
				#backlight {
					color: #${colors.base0A};
				}
				#wireplumber {
					color: #${colors.base0B};
				}
				#battery {
					color: #${colors.base0C};
				}
				#cpu {
					color: #${colors.base0D};
				}
				#memory {
					color: #${colors.base0E};
				}
				#clock {
					color: #${colors.base0F};
				}
			'';
			settings = {
				mainBar = {
					layer = "top";
					position = "top";
					height = 20;
					modules-left = [
						"image"
						"mpris"
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

					image = {
						exec = "${pkgs.writeShellScript "WaybarAlbumart" ''
							image=$(${pkgs.playerctl}/bin/playerctl metadata --format "{{ mpris:artUrl }}")
							echo "''${image#file://}"
						''}";
						interval = 1;
						size = 16;
						tooltip = false;
					};

					mpris = {
						format = " {artist} - {title} {position}/{length}";
						interval = 1;
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

{config, lib, pkgs, osConfig, home-manager, inputs, ...}:

let
cfg = config.userSettings.stylix;
theme = import (./. + "../../../themes" + ("/" + config.userSettings.stylix.theme));
in
{
	options = {
		userSettings.stylix = {
			enable = lib.mkOption {
				default = if (osConfig.stylix.enable) then true else false;
				type = lib.types.bool;
				description = "Enable stylix theming";
			};
			theme = lib.mkOption {
				default = if (osConfig.stylix.enable) then osConfig.systemSettings.stylix.theme else "gruvbox-dark-medium";
				type = lib.types.enum (builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ../../themes)));
				description = "theme to use with stylix";
			};
		};
	};

	imports = lib.optionals (!osConfig.stylix.enable) [ inputs.stylix.homeManagerModules.stylix ];

	config = lib.mkIf cfg.enable {
		stylix = {
			enable = true;
			autoEnable = false;
			polarity = theme.polarity;
			cursor = {
				package = pkgs.capitaine-cursors;
				name = "capitaine-cursors";
				size = 40;
			};
			image = pkgs.fetchurl {
				url = theme.backgroundUrl;
				sha256 = theme.backgroundSha256;
			};
			base16Scheme = theme;

			fonts = {
				monospace = {
					name = "FiraCode Nerd Font";
					package = pkgs.nerd-fonts.fira-code;
				};
				serif = {
					name = "Fira Sans";
					package = pkgs.fira-sans;
				};
				sansSerif = {
					name = "Fira Sans";
					package = pkgs.fira-sans;
				};
				emoji = {
					name = "Twitter Color Emoji";
					package = pkgs.twitter-color-emoji;
				};
				sizes = {
					terminal = 12;
					applications = 12;
					popups = 12;
					desktop = 12;
				};
			};
			targets.gtk.enable = true;
			targets.qt.enable = true;
			# reenable if a kirigami app doesn't work
			# targets.qt.platform = "gtk3";
			targets.kde.enable = true;
		};
		home.packages = with pkgs; [
			kdePackages.breeze kdePackages.breeze-icons
			nerd-fonts.fira-code fira-sans twitter-color-emoji adwaita-icon-theme
		];

		fonts.fontconfig.defaultFonts = {
			monospace = [ config.stylix.fonts.monospace.name ];
			sansSerif = [ config.stylix.fonts.sansSerif.name ];
			serif = [ config.stylix.fonts.serif.name ];
		};

	};
}

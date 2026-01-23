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
			targets.gtk.enable = true;
			targets.qt.enable = true;
			# reenable if a kirigami app doesn't work
			# targets.qt.platform = "gtk3";
			targets.kde.enable = true;
			targets.fontconfig.enable = true;
		};
		home.packages = with pkgs; [
			kdePackages.breeze kdePackages.breeze-icons
			nerd-fonts.fira-code fira-sans twitter-color-emoji adwaita-icon-theme
		];
		gtk = {
			enable = true;
			iconTheme = {
				name = if config.stylix.polarity == "dark" then "Papirus-Dark" else "Papirus-Light";
				package = pkgs.papirus-icon-theme;
			};
		};
	};
}

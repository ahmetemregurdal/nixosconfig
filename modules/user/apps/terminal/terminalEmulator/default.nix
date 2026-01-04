{pkgs, lib, config, ...}:

let
	terminal = config.userSettings.terminal;
in
{
	options = {
		userSettings.terminal = lib.mkOption {
			default = "foot";
			description = "Default terminal";
			type = lib.types.enum [ "kitty" "alacritty" "foot" ];
		};
		userSettings.spawnTerminal = lib.mkOption {
			default = "${pkgs.foot}/bin/foot";
			description = "Terminal spawn command";
			type = lib.types.str;
		};
	};

	config = {
		userSettings.kitty.enable = lib.mkDefault (terminal == "kitty");
		userSettings.alacritty.enable = lib.mkDefault (terminal == "alacritty");
		userSettings.foot.enable = lib.mkDefault (terminal == "foot");

		userSettings.spawnTerminal = lib.mkMerge [
			(lib.mkIf (terminal == "kitty") "${pkgs.kitty}/bin/kitty" )
			(lib.mkIf (terminal == "alacritty") "${pkgs.alacritty}/bin/alacritty" )
			(lib.mkIf (terminal == "foot") "${pkgs.foot}/bin/foot" )
		];
	};
}

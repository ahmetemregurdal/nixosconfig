{config, pkgs, lib, ...}:

let
	dmenu = config.userSettings.dmenu;
in
{
	options = {
		userSettings.dmenu = lib.mkOption {
			default = "fuzzel";
			description = "Dmenu wrapper to use";
			type = lib.types.enum [ "fuzzel" ];
		};
		userSettings.spawndmenu = lib.mkOption {
			default = "fuzzel --dmenu";
			description = "Command to launch dmenu";
			type = lib.types.str;
		};
	};

	config = {
		userSettings.fuzzel.enable = lib.mkDefault (dmenu == "fuzzel");

		userSettings.spawndmenu = lib.mkMerge [
			(lib.mkIf (dmenu == "fuzzel") "${lib.getExe pkgs.fuzzel} --dmenu")
		];
	};
}

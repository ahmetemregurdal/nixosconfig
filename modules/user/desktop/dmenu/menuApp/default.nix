{config, pkgs, lib, ...}:

let
	dmenu = config.userSettings.dmenu.app;
in
{
	options = {
		userSettings.dmenu.app = lib.mkOption {
			default = "fuzzel";
			description = "Dmenu wrapper to use";
			type = lib.types.enum [ "fuzzel" ];
		};
		userSettings.dmenu.cmd = lib.mkOption {
			default = "fuzzel --dmenu";
			description = "Command to launch dmenu";
			type = lib.types.str;
		};
	};

	config = {
		userSettings.fuzzel.enable = lib.mkDefault (dmenu == "fuzzel");

		userSettings.dmenu.cmd = lib.mkMerge [
			(lib.mkIf (dmenu == "fuzzel") "${lib.getExe pkgs.fuzzel} --dmenu")
		];
	};
}

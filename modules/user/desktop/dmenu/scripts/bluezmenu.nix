{config, lib, pkgs, ...}:

let
	spawnDmenu = config.userSettings.dmenu.cmd;
in
{
	options = {
		userSettings.dmenu.bzmenu = lib.mkOption {
			type = lib.types.str;
			default = "";
			description = "Dmenu bluetooth cmd";
		};
	};

	config = {
		userSettings.dmenu.bzmenu = "${lib.getExe pkgs.bzmenu} --launcher custom --launcher-command \\\"${spawnDmenu} -i\\\"";
	};
}


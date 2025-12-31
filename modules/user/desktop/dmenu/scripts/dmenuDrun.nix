{config, lib, pkgs, ...}:

let
	spawnDmenu = config.userSettings.dmenu.cmd;
	spawnTerm = config.userSettings.spawnTerminal;
in
{
	options = {
		userSettings.dmenu.drun = lib.mkOption {
			type = lib.types.str;
			default = "";
			description = "Dmenu Drun cmd";
		};
	};

	config = {
		userSettings.dmenu.drun = "${lib.getExe pkgs.j4-dmenu-desktop} --dmenu=\"${spawnDmenu} -i\" --term=\"${spawnTerm}\" --no-generic";
	};
}

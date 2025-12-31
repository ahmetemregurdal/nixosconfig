{config, lib, pkgs, ...}:

let
	spawnDmenu = config.userSettings.dmenu.cmd;
	spawnTerm = config.userSettings.spawnTerminal;
	spawnEditor = config.userSettings.spawnEditor;
	rbwmenu = pkgs.replaceVars ./rbwmenu.sh {
		dmenu = spawnDmenu;
		spawnTerm = spawnTerm;
		copyCmd = "wl-copy";
		dunstify = "${lib.getExe' pkgs.dunst "dunstify"}";
		editor = spawnEditor;
		rbw = "${lib.getExe pkgs.rbw}";
	};
in
{
	options = {
		userSettings.dmenu.rbwmenu = lib.mkOption {
			type = lib.types.str;
			description = "rbwmenu launch command";
			default = "";
		};
	};
	config = {
		userSettings.dmenu.rbwmenu = "${pkgs.writeShellScript "rbwmenu.sh" (builtins.readFile rbwmenu)}";
	};
}

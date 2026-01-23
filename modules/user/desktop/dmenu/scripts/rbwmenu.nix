{config, lib, pkgs, ...}:

let
	spawnDmenu = config.userSettings.dmenu.cmd;
	spawnTerm = config.userSettings.spawnTerminal;
	spawnEditor = config.userSettings.spawnEditor;
	rbwmenu = pkgs.replaceVars ./rbwmenu.sh {
		dmenu = spawnDmenu;
		spawnTerm = spawnTerm;
		copyCmd = "wl-copy";
		editor = spawnEditor;
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

		home.packages = [
			pkgs.rbw
			pkgs.dunst
		];
	};
}

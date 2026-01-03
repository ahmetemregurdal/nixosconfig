{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.shell.tmux;
in
{
	options = {
		userSettings.shell.tmux.enable = lib.mkEnableOption "Enable Tmux";
	};

	config = lib.mkIf cfg.enable {
		stylix.targets.tmux.enable = true;
		programs.tmux = {
			enable = true;
			baseIndex = 1;
			keyMode = "vi";
			terminal = "xterm-256color";
			escapeTime = 0;
			shortcut = "a";
			clock24 = true;
		};
		home.sessionVariables = {
			TINTED_TMUX_OPTION_STATUSBAR = 1;
		};
	};
}

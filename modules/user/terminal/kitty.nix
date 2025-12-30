{config, pkgs, lib, ...}:

let
	cfg = config.userSettings.kitty;
in
{
	options = {
		userSettings.kitty = {
			enable = lib.mkEnableOption "Enable Kitty";
		};
	};

	config = lib.mkIf cfg.enable {
		userSettings.stylix.enable = true;
		stylix.targets.kitty.enable = true;
		home.sessionVariables = {
			KITTY_SHELL_INTEGRATION_NO_SUDO = "1";
		};
		programs.kitty = {
			enable = true;
			settings = {
				confirm_os_window_close = 0;
				enable_audio_bell = false;
				scrollbar = "never";
				shell_integration = "no-sudo no-rc";
				paste_actions = "confirm-if-large";
			};
			keybindings = {
				"ctrl+equal" = "change_font_size all +2.0";
				"ctrl+minus" = "change_font_size all -2.0";
			};
		};
	};
}

{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.rbw;
in
{
	options = {
		userSettings.rbw = {
			enable = lib.mkEnableOption "Enable rbw";
			mail = lib.mkOption {
				default = "";
				description = "Mail adress to use with bitwarden";
				type = lib.types.str;
			};
		};
	};

	config = lib.mkIf cfg.enable {
		programs.rbw = {
			enable = true;
			settings = {
				email = cfg.mail;
				pinentry = pkgs.pinentry-qt;
			};
		};
	};
}

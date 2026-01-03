{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.pgp;
in
{
	options = {
		userSettings.pgp.enable = lib.mkEnableOption "Enable pgp";
	};

	config = lib.mkIf cfg.enable {
		services.gpg-agent = {
			enableZshIntegration = true;
			enable = true;
			pinentry = {
				package = pkgs.pinentry-qt;
			};
		};
	};
}

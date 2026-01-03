{config, pkgs, lib, ...}:

let
	cfg = config.userSettings.halloy;
in
{
	options = {
		userSettings.halloy.enable = lib.mkEnableOption "Enable Halloy";
	};

	config = lib.mkIf cfg.enable {
		stylix.targets.halloy.enable = true;
		programs.halloy = {
			enable = true;
			settings = {
				buffer.channel.topic = {
					enabled = true;
				};

				servers.liberachat = {
					channels = [
						"#nixos"
						"#halloy"
					];
					server = "irc.libera.chat";
					nickname = "int23_t";
				};
			};
		};
	};
}

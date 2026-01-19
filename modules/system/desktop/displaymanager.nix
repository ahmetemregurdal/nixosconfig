{pkgs, lib, config, ...}:

let
	cfg = config.systemSettings.displaymanager;
in
{
	options = {
		systemSettings.displaymanager.enable = lib.mkEnableOption "Enable DisplayManager";
	};

	config = lib.mkIf cfg.enable {
		systemSettings.stylix.enable = true;
		services.greetd.enable = true;
		programs.regreet.cageArgs = [ "-s" "-m" "last" ];
		services.greetd.settings.default_session = {
			command = "${lib.getExe' pkgs.dbus "dbus-run-session"} ${lib.getExe pkgs.cage} ${lib.escapeShellArgs config.programs.regreet.cageArgs} -- ${lib.getExe config.programs.regreet.package}";
			user = "greeter";
		};
		programs.regreet.enable = true;
		stylix.targets.regreet.enable = true;
		stylix.targets.gtk.enable = true;
	};
}

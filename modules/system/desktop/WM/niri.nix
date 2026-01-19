{config, pkgs, lib, ...}:
let
	cfg = config.systemSettings.niri;
in
{
	options = {
		systemSettings.niri.enable = lib.mkEnableOption "Enable Niri Wayland Compositor";
	};

	config = lib.mkIf cfg.enable {
		programs.niri = {
			enable = true;
		};
		services.upower.enable = true;
		environment.systemPackages = with pkgs; [
			xwayland-satellite
		];
	};
}

{pkgs, lib, config, ...}:

let
	cfg = config.systemSettings.security.firewall;
in
{
	options = {
		systemSettings.security.firewall.enable = lib.mkEnableOption "Enable Firewall";
	};

	config = lib.mkIf cfg.enable {
		networking.firewall = {
			enable = true;
			allowedTCPPorts = [
				23230
			];
			allowedUDPPorts = [
				23230
			];
			trustedInterfaces = [
				"tailscale0"
			];
		};
	};
}

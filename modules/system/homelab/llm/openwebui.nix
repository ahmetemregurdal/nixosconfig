{config, lib, pkgs, ...}:

let
	cfg = config.selfhosting.llm;
in
{
	config = lib.mkIf cfg.enable {
		services.open-webui = {
			# enable = true;
			port = 8888;
			host = "0.0.0.0";
			environment = {
				ANONYMIZED_TELEMETRY = "False";
				DO_NOT_TRACK = "True";
				SCARF_NO_ANALYTICS = "True";
				WEBUI_AUTH = "False";
			};
		};
	};
}

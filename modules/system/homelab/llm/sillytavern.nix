{config, lib, pkgs, ...}:

let
	cfg = config.selfhosting.llm;
in
{
	config = lib.mkIf cfg.enable {
		services.sillytavern = {
			enable = true;
			port = 8045;
			listen = true;
			listenAddressIPv4 = "0.0.0.0";
		};

		systemd.services.sillytavern.serviceConfig = {
			ExecStart = lib.mkForce ''
				${pkgs.sillytavern}/bin/sillytavern \
				--port 8045 \
				--listen true \
        --listenAddress 0.0.0.0 \
        --whitelist false \
				--basicAuthMode true \
			'';
		};
	};
}

{config, lib, pkgs, ...}:

let
	cfg = config.selfhosting.matrix;
in
{
	options = {
		selfhosting.matrix = {
			enable = lib.mkEnableOption "Enable Matrix";
			enableMautrix = lib.mkEnableOption "Enable Mautrix";
		};
	};

	config = lib.mkIf cfg.enable {
		services.matrix-continuwuity = {
			enable = true;
			settings.global = {
				port = [ 6167 ];
				server_name = "gurdal";
			};
		};

		services.mautrix-signal = {
			enable = cfg.enableMautrix;
			settings = {
				appservice = {
					as_token = "";
					bot = {
						displayname = "Signal Bridge Bot";
						username = "signalbot";
					};
					hostname = "[::]";
					hs_token = "";
					id = "signal";
					port = 29328;
					username_template = "signal_{{.}}";
				};
				bridge = {
					command_prefix = "!signal";
					permissions = {
						"*" = "relay";
					};
					relay = {
						enabled = true;
					};
				};
				database = {
					type = "sqlite3";
					uri = "file:/var/lib/mautrix-signal/mautrix-signal.db?_txlock=immediate";
				};
				direct_media = {
					server_key = "";
				};
				double_puppet = {
					secrets = { };
					servers = { };
				};
				encryption = {
					pickle_key = "";
				};
				homeserver = {
					address = "http://localhost:6167";
				};
				logging = {
					min_level = "info";
					writers = [
						{
							format = "pretty-colored";
							time_format = " ";
							type = "stdout";
						}
					];
				};
				network = {
					displayname_template = "{{or .ProfileName .PhoneNumber \"Unknown user\"}}";
				};
				provisioning = {
					shared_secret = "";
				};
				public_media = {
					signing_key = "";
				};

			};
		};
		nixpkgs.config.permittedInsecurePackages = [
			"olm-3.2.16"
		];
	};
}

{config, pkgs, lib, ...}:

let
	cfg = config.systemSettings.bluetooth;
in
{
	options = {
		systemSettings.bluetooth = {
			enable = lib.mkEnableOption "Enable Bluetooth";
		};
	};

	config = lib.mkIf cfg.enable {
		hardware.bluetooth = {
			enable = true;
			powerOnBoot = true;
			settings = {
				General = {
					Experimental = true;
					FastConnectable = true;
				};
			};
		};
	};
}

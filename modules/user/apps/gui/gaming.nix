{config, lib, pkgs, osConfig, ...}:

let
	cfg = config.userSettings.gaming;
	switchKeys = pkgs.fetchzip {
		url = "https://files.prodkeys.net/Prodkeys.NET_v21-0-0.zip";
		name = "switchKeys";
		sha256 = "sha256-AExcHZjTU925k3If3l8saGXbTfAE8GAU/kvZeBboFhA=";
		stripRoot = false;
	};
	switchFirm = pkgs.fetchurl {
		url = "https://github.com/THZoria/NX_Firmware/releases/download/21.0.0/Firmware.21.0.0.zip";
		name = "switchFirm";
		sha256 = "sha256-HFUtOMtXrO6Xaf3MZwee8VB3lZOolRz4WSl48d9zlKE=";
	};

	customRetroArch = pkgs.retroarch.withCores(cores: with pkgs.libretro; [
		nestopia
	]);

	nesFirm = pkgs.fetchurl {
		url = "https://raw.githubusercontent.com/Abdess/retroarch_system/libretro/Nintendo%20-%20Famicom%20Disk%20System/disksys.rom";
		name = "nesFirm";
		sha256 = "sha256-mcGEkO2QAtnG2Zm52NFb5cBRvfp8x+czGAU8mplLAXg=";
	};
in
{
	options = {
		userSettings.gaming.enable = lib.mkOption {
			default = osConfig.systemSettings.gaming.enable;
			description = "Enable Home-Manager gaming settings";
			type = lib.types.bool;
		};
	};

	config = lib.mkIf cfg.enable {
		programs.lutris = {
			enable = true;
			defaultWinePackage = pkgs.proton-ge-bin;
			steamPackage = osConfig.programs.steam.package;
			winePackages = [ pkgs.proton-ge-bin ];
			protonPackages = [ pkgs.proton-ge-bin ];
			runners = {
				ryujinx = {
					package = pkgs.ryubing;
					settings.runner = {
						prod_keys = "${switchKeys}/prod.keys";
						title_keys = "${switchKeys}/title.keys";
					};
				};
				libretro = {
					package = customRetroArch;
				};
			};
		};

		home.file.".config/Ryujinx/system/prod.keys" = {
			source = "${switchKeys}/prod.keys";
			enable = true;
		};

		home.file.".config/Ryujinx/system/title.keys" = {
			source = "${switchKeys}/title.keys";
			enable = true;
		};

# TODO: Make installation of firmware automated
		home.file.".config/Ryujinx/FIRMWARE.zip" = {
			source = switchFirm;
			enable = true;
		};

		home.file.".local/share/lutris/runners/retroarch/cores" = {
			source = "${customRetroArch}/lib/retroarch/cores";
		};

		home.file."Games/BIOSs/disksys.rom" = {
			source = nesFirm;
		};

		home.file.".config/retroarch/system/disksys.rom" = {
			source = nesFirm;
		};
	};
}

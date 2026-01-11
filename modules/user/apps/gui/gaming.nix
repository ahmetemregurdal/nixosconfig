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
		bsnes
	]);

	libretroFirm = pkgs.fetchFromGitHub {
		owner = "Abdess";
		repo = "retroarch_system";
		rev = "5f96368f6dbad5851cdb16a5041fefec4bdcd305";
		sha256 = "sha256-h6tTjB4hVsnTRwmtC9Gm3HMLZmPP8KNRUdrlh1cjg58=";
	};
	nesFirm = "${libretroFirm}/Nintendo - Famicom Disk System/disksys.rom";
	snesFirm = "${libretroFirm}/Nintendo - Super Nintendo Entertainment System";
	superGameBoyFirm = "${libretroFirm}/Nintendo - Super Game Boy/SGB1.sfc";
	superGameBoyFirm2 = "${libretroFirm}/Nintendo - Super Game Boy/SGB2.sfc";
	satellaviewFirm = "${libretroFirm}/Nintendo - Satellaview/BS-X.bin";
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
				dolphin = {
					package = pkgs.dolphin-emu;
				};
				cemu = {
					package = pkgs.cemu;
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

		home.file.".config/retroarch/system/disksys.rom".source = nesFirm;
		home.file.".config/retroarch/system" = {
			source = snesFirm;
			recursive = true;
		};
		home.file.".config/retroarch/system/SGB1.sfc".source = nesFirm;
		home.file.".config/retroarch/system/SGB2.sfc".source = nesFirm;
		home.file.".config/retroarch/system/BS-X.bin".source = satellaviewFirm;
		home.file."Games/BIOSs/disksys.rom".source = nesFirm;
		home.file."Games/BIOSs" = {
			source = snesFirm;
			recursive = true;
		};
		home.file."Games/BIOSs/SGB1.sfc".source = superGameBoyFirm;
		home.file."Games/BIOSs/SGB2.sfc".source = superGameBoyFirm2;
		home.file."Games/BIOSs/BS-X.bin".source = satellaviewFirm;
	};
}

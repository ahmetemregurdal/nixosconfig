{lib, config, pkgs, ...}:

let
	cfg = config.systemSettings.cachy;
in
{
	options = {
		systemSettings.cachy = {
			enable = lib.mkEnableOption "Enable cachyos kernel";
			variant = lib.mkOption {
				default = null;
				type = lib.types.nullOr (lib.types.enum ["lto" "lts" "server" "hardened"]);
				description = "CachOS kernel cariant to use";
			};
		};
	};

	config = lib.mkIf cfg.enable {
		boot.kernelPackages = lib.mkForce lib.mkMerge [
			(lib.mkIf (cfg.variant == null) pkgs.linuxPackages_cachyos)
			(lib.mkIf (cfg.variant == "lts") pkgs.linuxPackages_cachyos-lts)
			(lib.mkIf (cfg.variant == "lto") pkgs.linuxPackages_cachyos-lto)
			(lib.mkIf (cfg.variant == "server") pkgs.linuxPackages_cachyos-server)
			(lib.mkIf (cfg.variant == "hardened") pkgs.linuxPackages_cachyos-hardened)
		];
	};
}

{config, lib, pkgs, ...}:

let
	cfg = config.systemSettings.virtualisation;
in
{
	options = {
		systemSettings.virtualisation.enable = lib.mkEnableOption "Enable Virtualisation";
	};

	config = lib.mkIf cfg.enable {
		virtualisation.libvirtd = {
			enable = true;
			qemu = {
				package = pkgs.qemu_kvm;
				swtpm.enable = true;
			};
		};

		virtualisation.spiceUSBRedirection.enable = true;

		users.groups.libvirtd.members = config.systemSettings.adminUsers;
		users.groups.kvm.members = config.systemSettings.adminUsers;

		environment.systemPackages = [
			pkgs.gnome-boxes
			pkgs.dnsmasq
		];
	};
}

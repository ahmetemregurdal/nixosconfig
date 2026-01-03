{config, pkgs, lib, ...}:

{
	home.packages = with pkgs; [
		qbittorrent
		qalculate-qt
		signal-desktop-bin
	];
}

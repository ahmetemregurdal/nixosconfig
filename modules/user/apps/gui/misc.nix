{config, pkgs, lib, ...}:

{
	home.packages = with pkgs; [
		qbittorrent
		signal-desktop-bin
	];
}

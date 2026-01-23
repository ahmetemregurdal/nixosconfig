{config, pkgs, lib, ...}:

{
	home.packages = with pkgs; [
		qbittorrent
		flare-signal
		dissent
		qalculate-qt
		fractal
	];
}

{config, lib, pkgs, inputs, ...}:

let
	cfg = config.userSettings.languages;
in
{
	options = {
		userSettings.languages = {
			cpp.enable = lib.mkEnableOption "Enable c/c++";
			nix.enable = lib.mkEnableOption "Enable fancy nix";
			qml.enable = lib.mkEnableOption "Enable QML";
		};
	};

	config = {
	};
}

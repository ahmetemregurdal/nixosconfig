{config, lib, pkgs, osConfig, ...}:

let
	cfg = config.userSettings.niri;
	font = config.stylix.fonts.monospace.name;
	colors = config.lib.stylix.colors;
	cursor = config.stylix.cursor;
	term = config.userSettings.terminal;
	spawnTerm = config.userSettings.spawnTerminal;
	spawnBrowser = config.userSettings.spawnBrowser;
	spawnEditor = config.userSettings.spawnEditor;
	dmenu = config.userSettings.dmenu;
	niriConfig = pkgs.runCommand "niri-config.kdl" {} ''
		substitute ${./config.kdl} $out \
			--replace-fail "@bluetoothmenu@" '${dmenu.bzmenu}' \
			--replace-fail "@dmenudrun@" '${dmenu.drun}' \
			--replace-fail "@rbwmenu@" '${dmenu.rbwmenu}' \
			--replace-fail "@term@" '${term}' \
			--replace-fail "@editor@" '${spawnEditor}' \
			--replace-fail "@browser@" '${spawnBrowser}' \
			--replace-quiet "@base01@" '${colors.base01}' \
			--replace-quiet "@base03@" '${colors.base03}' \
			--replace-quiet "@base0D@" '${colors.base0D}' \
			--replace-fail "@cursor@" '${cursor.name}' \
			--replace-fail "@cursorSize@" '${builtins.toString cursor.size}'
	'';
in
{
	options = {
		userSettings.niri = {
			enable = lib.mkOption {
				default = osConfig.systemSettings.niri.enable;
				type = lib.types.bool;
				description = "Enable Niri HomeManager";
			};
		};
	};

	config = lib.mkIf cfg.enable {
		home.sessionVariables = {
			XDG_CURRENT_DESKTOP = "Niri";
			NIXOS_OZONE_WL = "1";
			ELECTRON_OZONE_PLATFORM_HINT = "auto";
			XDG_SESSION_TYPE = "wayland";
		};

		home.file.".config/niri/config.kdl".source = niriConfig;

		services.wpaperd.enable = true;
		stylix.targets.wpaperd.enable = true;

		home.packages = with pkgs; [
			wl-clipboard
			brightnessctl
			grim
			slurp
			satty
			wireplumber
		];

		services.wl-clip-persist = {
			enable = true;
		};

		stylix.targets.fnott.enable = true;
		services.fnott = {
			enable = true;
		};
	};
}

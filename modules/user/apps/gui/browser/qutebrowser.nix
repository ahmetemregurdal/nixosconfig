{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.qutebrowser;
	term = config.userSettings.terminal;
in
{
	options = {
		userSettings.qutebrowser = {
			enable = lib.mkEnableOption "Enable qutebrowser";
		};
	};

	config = lib.mkIf cfg.enable {
		userSettings.stylix.enable = true;
		userSettings.shell.useful.enable = true;
		stylix.targets.qutebrowser.enable = true;
		programs.qutebrowser = {
			enable = true;
			loadAutoconfig = true;
			greasemonkey = [
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/461288/Bullyforces.user.js";
					sha256 = "1ppp1babzai5ch19pz051gq1zqqhmcjpwsld0gidryxwpx03gdr2";
				})
				(pkgs.fetchurl {
					url = "https://raw.githubusercontent.com/torrq/rut-english/refs/heads/main/rutracker-in-english.user.js";
					sha256 = "sha256-5PmJxtMiWSdLaIXpwATZEL9mlZo1DrRpiQunhbxl6uE=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/371117/cf-fast-submit.user.js";
					sha256 = "sha256-5rJo5VZGZqQGC6j4Ei1ovT76xHWIl4dpbLeIWqGeitQ=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/511077/carrot-script.user.js";
					sha256 = "09n0zvzpn2iial53qcflzf6akd7pd488zgm7q0qfc3f2ffjs8989";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/402180/Codeforces%20Performance.user.js";
					sha256 = "sha256-s7oRjJWxzUIUvmUlNEOKOaJ5g9DZbU/sm3zwakz4ryY=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/465176/CF%E8%A7%A3%E9%A2%98%E6%95%B0%E6%8D%AE%E5%8F%AF%E8%A7%86%E5%8C%96.user.js";
					sha256 = "sha256-gF3Q68oV3dt3doq3vaP/g1nJw1ZqQeiOW4PdDcRdPTs=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/369954/ac-predictor.user.js";
					sha256 = "sha256-swv1x/rhQwbemJ+jNV376xlWGhAIo0Rv/02IjbABtpg=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/383817/AtCoder%20Submission%20Status.user.js";
					sha256 = "sha256-P0b+McTQGcWq6KgPy2c3mzk0YqmYNQqIjJ3z8hbAqKA=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/474544/OJUZ%20enhancement.user.js";
					sha256 = "sha256-tGpo2bD/mOHNz9CFNdDRosQtkWNH1iK8kl6QkV0xbh0=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/457352/Stop%20wikipedia%20from%20screaming%20at%20me.user.js";
					sha256 = "sha256-naOx1g4juvvMfiBV1ZIJR3271I2hhAJ6wIrETsQZuDI=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/372/Expand%20Wikipedia%20Acronyms.user.js";
					sha256 = "sha256-nMvGKkej8ljCr+yYG3MIvhxrkjOccUL/cK8YnJU4XFA=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/446769/Add%20success%20percentage.user.js";
					sha256 = "sha256-KaUCULplhAgqqRC8ryJ0SxkgnK1m07VPk+BcaflNzd4=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/534112/CSES%20copy%20button.user.js";
					sha256 = "sha256-B+1gmJGnZ+JUcSKm3Jqv+zfi8Db4K/GAXsOf3FC9mWU=";
				})
				(pkgs.fetchurl {
					url = "https://update.greasyfork.org/scripts/557074/Submit%20Text%20on%20CSES.user.js";
					sha256 = "sha256-OB3Rl/UHvQCZ8BmAHC2gXa65KLll8eLMuA+rH8Wmmqs=";
				})
			];
			keyBindings = {
				normal = {
					"!" = "cmd-set-text :open -t !";
				};
			};
			searchEngines = {
				DEFAULT = "https://duckduckgo.com/?q={}";
				nix = "https://mynixos.com/search?q={}";
			};
			settings = {
				changelog_after_upgrade = "patch";
				colors.webpage = {
					preferred_color_scheme = config.stylix.polarity;
					darkmode.enabled = (config.stylix.polarity == "dark");
				};
				content = {
					blocking.method = "both";
					blocking.adblock.lists = [
						"https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt"
						"https://easylist.to/easylist/easylist.txt"
						"https://easylist.to/easylist/easyprivacy.txt"
					];
					pdfjs = true;
				};
				scrolling.smooth = true;

				downloads = {
					remove_finished = 2000;
					location.remember = false;
				};

				editor.command = config.userSettings.spawnEditorArgList ++ ["{}"];

				confirm_quit = [ "downloads" ];

				tabs = {
					position = "left";
					favicons.scale = 1.0;
					width = "5%";
					show = "multiple";
					title.format = "{index} {audio}";
				};

				hints.radius = 0;

				qt = {
					chromium = {
						experimental_web_platform_features = "always";
					};
					args = [
						"enable-gpu-rasterization"
						"ignore-gpu-blocklist"
					];
				};
				
				window.hide_decoration = true;
			};
		};
	};
}

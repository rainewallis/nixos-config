
{ pkgs, config, raine, nix-colors, stylix, ... }:
let 
  nix-colors-lib = nix-colors.lib.contrib { inherit pkgs; };
in {
  home.username = raine.user.settings.username;
  home.homeDirectory = "/home/" + raine.user.settings.username;
  home.stateVersion = "23.11";

  # imports = [
  #   nix-colors.homeManagerModules.default
  # ];
  #
  # colorScheme = nix-colors-lib.colorSchemeFromPicture {
  #   path = ./wallpapers/art_sunset_beach_96140_3840x2160.jpg;
  #   variant = "light";
  # };

  # colorScheme = nix-colors.colorSchemes.paraiso;

  # xresources.properties = {
  #  "Xcursor.size" = 16;
  #  "Xft.dpi" = 172;
  # };

  home.packages = with pkgs; [
    # Hyprland related
    waybar
    foot
    hyprpaper

    neofetch
    btop
    nerdfonts
    just
  ];
  
  imports = [
    stylix.homeManagerModules.stylix
  ];

  stylix = {
    image = ./wallpapers/art_sunset_beach_96140_3840x2160.jpg;
    polarity = "dark";

    opacity.desktop = 0.0;
    opacity.terminal = 0.5; 

    targets = {
      gtk.enable = true;
      foot.enable = true;
      kde.enable = false;
    };
  };

  home.file = {
    hyrpaper-conf = {
      enable = true;
      source = ./user/hyprland/hyprpaper.conf;
      target = ".config/hypr/hyprpaper.conf";
    };
    wallpapers = {
      enable = true;
      source = ./wallpapers;
      target = ".config/wallpapers";
    };
  };

  programs.git.enable = true;
  programs.git.userEmail = "raine@rainew.dev";
  programs.git.userName = "Raine Wallis";

  # gtk = {
  #   enable = true;
  #   # theme = {
  #   #   name = "${config.colorScheme.slug}";
  #   #   package = nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
  #   # };
  #   theme.name = "paraiso";
  # };

  # qt = {
  #   enable = true;
  #   platformTheme = "gtk";
  # };
  

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    monitor = [
      "Virtual-1, 1920x1080, 0x0, 1.25"
      ", preferred, auto, 1"
    ];

    input = {
      kb_layout = "gb";
      follow_mouse = 1;
      accel_profile = "flat";
    };

    decoration = {
      rounding = 15;
      # active_opacity = 0.8;
      # inactive_opacity = 0.8;
      dim_inactive = true;
    };
    bind = [
      "$mod, F, exec, firefox"
      "$mod, L, exec, foot"
      "$mod, M, exit"
      "$mod, W, exec, wofi --show=run"
      "$mod, C, closewindow"
    ]
    ++ (
      builtins.concatLists (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]
      )
      10)
    );
    exec-once = [
      "waybar"
      "hyprpaper"
    ];
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        margin = "3 7 3 7";
        output = [
          "Virtual-1"
        ];

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "temperature" ];
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 1000;
        font-family: Source Code Pro;
        background-color: transparent;
        color: #cccccc;
      }
    '';
  };

  programs.wofi = {
    enable = true;
  };
  programs.foot.enable = true;

}

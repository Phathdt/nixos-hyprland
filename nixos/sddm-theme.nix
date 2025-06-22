{ pkgs, ... }:

let
  sddm-astronaut-custom = pkgs.sddm-astronaut.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      # Create custom theme config
      cat > $out/share/sddm/themes/sddm-astronaut/theme.conf << EOF
[General]
Background="Backgrounds/astronaut.jpg"
DimBackgroundImage="0.0"
ScaleImageCropped=true
ScreenWidth=1920
ScreenHeight=1080

[Design]
MainColor="#c792ea"
AccentColor="#82aaff"
BackgroundColor="#292d3e"
OverrideLoginButtonTextColor="#eeffff"
InterfaceShadowSize=6
InterfaceShadowOpacity=0.6
RoundCorners=20
ScreenPadding=0
Font="JetBrainsMono Nerd Font"

[Input]
PLACEHOLDER_TEXT_COLOR="#676e95"
PLACEHOLDER_FONT_SIZE=18
INPUT_TEXT_COLOR="#eeffff"
INPUT_BACKGROUND_COLOR="#3a3f58"
INPUT_BORDER_COLOR="#676e95"

[Button]
BUTTON_TEXT_COLOR="#eeffff"
BUTTON_BACKGROUND_COLOR="#c792ea"
BUTTON_BORDER_COLOR="#c792ea"
HOVER_BUTTON_BACKGROUND_COLOR="#82aaff"
HOVER_BUTTON_BORDER_COLOR="#82aaff"

[Clock]
CLOCK_COLOR="#eeffff"
CLOCK_FONT_SIZE=72
EOF

      # Update metadata to use astronaut theme by default
      sed -i 's/ConfigFile=.*/ConfigFile=Themes\/astronaut.conf/' $out/share/sddm/themes/sddm-astronaut/metadata.desktop
    '';
  });
in
{
  environment.systemPackages = [ sddm-astronaut-custom ];
}

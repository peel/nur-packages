{ pkgs }:

{
  metals = pkgs.callPackage ./development/tools/metals {};
  scripts = pkgs.callPackage ./misc/scripts {
    inherit pkgs; inherit (pkgs) stdenv;
  };
} // (if pkgs.stdenv.isDarwin then {
  yabai = pkgs.callPackage ./os-specific/darwin/yabai {
    inherit (pkgs) stdenv fetchFromGitHub;
    inherit (pkgs.darwin.apple_sdk.frameworks) Carbon Cocoa ScriptingBridge;
  };
  } else {
  rofi-emoji = pkgs.callPackage ./misc/rofi-emoji {};
  rofi-wifi-menu = pkgs.callPackage ./misc/rofi-wifi-menu {};
})

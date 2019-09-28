{ pkgs }:

let
  mkCoursierBinary = import ./development/tools/lib.nix { inherit (pkgs) stdenv jdk jre coursier makeWrapper;};
in {
  emacsPlus = let
    patchMulticolorFonts = pkgs.fetchurl {
        url = "https://gist.githubusercontent.com/aatxe/260261daf70865fbf1749095de9172c5/raw/214b50c62450be1cbee9f11cecba846dd66c7d06/patch-multicolor-font.diff";
        sha256 = "5af2587e986db70999d1a791fca58df027ccbabd75f45e4a2af1602c75511a8c";
    };
    # needs 10.11 sdk
    patchBorderless = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/peel/GNU-Emacs-OS-X-no-title-bar/master/GNU-Emacs-OS-X-no-title-bar.patch";
        sha256 = "0cjmc0nzx0smc4cxmxcjy75xf83smah3fkjfyql1y14gd59c1npw";
    };
    patchPixelScrolling = pkgs.fetchurl {
        url = "https://gist.githubusercontent.com/aatxe/ecd14e3e4636524915eab2c976650576/raw/c20527ab724ddbeb14db8cc01324410a5a722b18/emacs-pixel-scrolling.patch";
        sha256 = "34654d889e8a02aedc0c39a0f710b3cc17d5d4201eb9cb357ecca6ed1ec24684";
    };
    patch24bitColor = pkgs.fetchurl {
        url = "https://gist.githubusercontent.com/akorobov/2c9f5796c661304b4d8aa64c89d2cd00/raw/2f7d3ae544440b7e2d3a13dd126b491bccee9dbf/emacs-25.2-term-24bit-colors.diff";
        sha256 = "ffe72c57117a6dca10b675cbe3701308683d24b62611048d2e7f80f419820cd0";
    };
  in {
      with24bitColor ? false
    , withPixelScrolling ? false
    , withBorderless ? false
    , withMulticolorFonts ? false
  }: (pkgs.emacs
      .override{srcRepo=true;inherit (pkgs) autoconf automake texinfo;})
      .overrideAttrs (oldAttrs: rec {
        patches = oldAttrs.patches
          ++ pkgs.lib.optional with24bitColor patch24bitColor
          ++ pkgs.lib.optional withPixelScrolling patchPixelScrolling
          ++ pkgs.lib.optional withBorderless patchBorderless
          ++ pkgs.lib.optional withMulticolorFonts patchMulticolorFonts;
      });
  _1pa = pkgs.callPackage ./tools/security/_1pa {};
  gopass = pkgs.callPackage ./tools/security/gopass {};
  hoverfly = pkgs.callPackage ./development/tools/hoverfly {};
  ix = pkgs.callPackage ./misc/ix {};
  mill = pkgs.callPackage ./development/tools/mill {};
  metals = pkgs.callPackage ./development/tools/metals {};
  qarma = pkgs.callPackage ./misc/qarma {
    inherit (pkgs) stdenv fetchFromGitHub pkgconfig;
    inherit (pkgs.qt5) qtbase qmake qttools qtmacextras qtx11extras;
  };
  # remacs = pkgs.callPackage ./pkgs/applications/editors/emacs/remacs.nix {};
  scripts = pkgs.callPackage ./misc/scripts {
    inherit pkgs; inherit (pkgs) stdenv;
  };
  tmux-prompt = pkgs.callPackage ./misc/tmux-prompt {};
  zenity = pkgs.callPackage ./misc/zenity {};
} // (if pkgs.stdenv.isDarwin then {
  yabai = pkgs.callPackage ./os-specific/darwin/yabai {
    inherit (pkgs) stdenv fetchFromGitHub;
    inherit (pkgs.darwin.apple_sdk.frameworks) Carbon Cocoa ScriptingBridge;

  };
  } else {
  rofi-emoji = pkgs.callPackage ./misc/rofi-emoji {};
  rofi-wifi-menu = pkgs.callPackage ./misc/rofi-wifi-menu {};
})

{
  pkgs,
  self,
}: {
  packages.${pkgs.stdenv.hostPlatform.system} = {
    votv = pkgs.callPackage ./package.nix {wine = pkgs.wineWow64Packages.waylandFull;};
  };
  apps.${pkgs.stdenv.hostPlatform.system} = {
    votv = {
      type = "app";
      program = "${pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.votv}";
      meta.description = "An early-access indie horror simulation video game";
    };
  };
}

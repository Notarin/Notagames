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
      meta.description = self.packages.${pkgs.stdenv.hostPlatform.system}.votv.meta.description;
    };
  };
}

{
  # std+lib
  lib,
  stdenv,
  # fetcher(s)
  fetchurl,
  # build helper(s)
  makeDesktopItem,
  # dependencies
  p7zip,
  wine,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "Voices of the Void";
  version = "a09b_0004";
  src = fetchurl {
    url = "https://archive.votv.zip/VDMR/${finalAttrs.version}.7z";
    hash = "sha256-hkdCssr4GgNxfzyT0bWjx8ys0p2WgNQsQJR9s3insoM=";
  };
  buildInputs = [p7zip wine];

  buildPhase = ''
    runHook preBuild

    echo -e "#!${stdenv.shell}

    WINEPREFIX=\$HOME/.local/share/VotV ${lib.getExe wine}  $out/VotV.exe" > ./${finalAttrs.meta.mainProgram}
    chmod +x ./${finalAttrs.meta.mainProgram}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mkdir -p $out/bin
    mkdir -p $out/share
    # Game files
    cp -r WindowsNoEditor/* $out/
    # Start script
    cp ./${finalAttrs.meta.mainProgram} $out/bin/${finalAttrs.meta.mainProgram}
    # .desktop file
    ln -s "$desktopItem/share/applications" $out/share/

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = finalAttrs.meta.mainProgram;
    desktopName = finalAttrs.pname;
    icon = fetchurl {
      url = "https://votv.dev/assets/body/logo.png";
      hash = "sha256-pEv5DMgCjNNXBvsNf8/hPiFMPeR0fz5OXLsOcBDWWao=";
    };
    exec = finalAttrs.meta.mainProgram;
    categories = ["Game"];
    keywords = [finalAttrs.meta.mainProgram];
    singleMainWindow = true;
  };

  meta = {
    homepage = "https://votv.dev/";
    description = "An early-access indie horror simulation video game";
    maintainers = with lib.maintainers; [notarin];
    platforms = lib.platforms.linux;
    mainProgram = "votv";
  };
})

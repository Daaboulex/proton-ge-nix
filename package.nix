{
  lib,
  stdenvNoCC,
  fetchzip,
  variant ? "x86_64",
  steamDisplayName ? "GE-Proton",
}:
let
  hashX64 = "sha256-I7SSvzQQ/NqdvwjpJ9IFFtAaTS+rgHUyXx0us1vIOnw=";
  hashArm64 = "sha256-BT6yBrXL0iv+ylbxKrZB5L/NvJom+ZrdNrQDcZkSDVU=";
  version = "GE-Proton11-1";
  variantSrc =
    asset: hash:
    fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${asset}";
      inherit hash;
    };
  variantSrcs = {
    x86_64 = variantSrc "${version}.tar.gz" hashX64;
    aarch64 = variantSrc "${version}-aarch64.tar.gz" hashArm64;
  };
in
stdenvNoCC.mkDerivation {
  pname = "proton-ge" + lib.optionalString (variant != "x86_64") "-${variant}";
  inherit version;

  src = variantSrcs.${variant};

  allVariantSources = lib.optionals (variant == "x86_64") (lib.attrValues variantSrcs);

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall
    echo "proton-ge is a Steam compatibility tool; consume the steamcompattool output via programs.steam.extraCompatPackages." > $out
    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool
    substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
      --replace-fail "${version}" "${steamDisplayName}"
    runHook postInstall
  '';

  meta = {
    description = "GE-Proton prebuilt Steam Play compatibility tool (${variant} build), stable GE-Proton dropdown identity";
    homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
    license = lib.licenses.bsd3;
    platforms = if variant == "aarch64" then [ "aarch64-linux" ] else [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}

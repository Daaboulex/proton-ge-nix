{
  lib,
  stdenvNoCC,
  fetchzip,
  tag,
  hashX64,
  hashArm64 ? null,
  variant ? "x86_64",
  steamDisplayName ? "GE-Proton",
}:
let
  assetOf = v: if v == "aarch64" then "${tag}-aarch64.tar.gz" else "${tag}.tar.gz";
  hashOf = v: if v == "aarch64" then hashArm64 else hashX64;
  fetchVariant =
    v:
    fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${tag}/${assetOf v}";
      hash = hashOf v;
    };
  variantSrcs = {
    x86_64 = fetchVariant "x86_64";
  }
  // lib.optionalAttrs (hashArm64 != null) {
    aarch64 = fetchVariant "aarch64";
  };
in
stdenvNoCC.mkDerivation {
  pname = "proton-ge" + lib.optionalString (variant != "x86_64") "-${variant}";
  version = tag;

  src = fetchVariant variant;

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
      --replace-fail "${tag}" "${steamDisplayName}"
    runHook postInstall
  '';

  meta = {
    description = "GE-Proton prebuilt Steam Play compatibility tool (${tag}, ${variant} build), stable dropdown identity";
    homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
    license = lib.licenses.bsd3;
    platforms = if variant == "aarch64" then [ "aarch64-linux" ] else [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}

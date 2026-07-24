{
  pkgs,
  lib ? pkgs.lib,
}:
let
  sources = import ./sources.nix;
  variant = if pkgs.stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";

  majorOf = tag: lib.head (builtins.match "GE-Proton([0-9]+)-.*" tag);

  allReleases = {
    ${sources.version} = {
      inherit (sources) variants;
    };
  }
  // sources.pins;

  buildableHere = tag: allReleases.${tag}.variants ? ${variant};

  mk =
    tag: steamDisplayName:
    pkgs.callPackage ./package.nix {
      inherit tag variant steamDisplayName;
      hash = allReleases.${tag}.variants.${variant};
    };

  latestDrv = mk sources.version "GE-Proton-latest";

  majorTags = lib.filter buildableHere (lib.attrNames allReleases);
  majorChannels = lib.listToAttrs (
    map (tag: {
      name = "v${majorOf tag}";
      value = mk tag "GE-Proton ${lib.removePrefix "GE-Proton" tag}";
    }) majorTags
  );

  channels = majorChannels // {
    latest = latestDrv;
  };
in
{
  proton-ge = latestDrv.overrideAttrs (old: {
    passthru = (old.passthru or { }) // channels;
  });
  inherit channels;
}

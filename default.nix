{
  pkgs,
  lib ? pkgs.lib,
}:
let
  sources = import ./sources.nix;
  isArm = pkgs.stdenv.hostPlatform.isAarch64;
  variant = if isArm then "aarch64" else "x86_64";

  majorOf = tag: lib.head (builtins.match "GE-Proton([0-9]+)-.*" tag);

  allReleases = {
    ${sources.version} = {
      inherit (sources) hashX64 hashArm64;
    };
  }
  // sources.pins;

  buildableHere = rel: if isArm then (rel.hashArm64 or null) != null else true;

  mk =
    tag: steamDisplayName:
    pkgs.callPackage ./package.nix {
      inherit tag variant steamDisplayName;
      hashX64 = allReleases.${tag}.hashX64;
      hashArm64 = allReleases.${tag}.hashArm64 or null;
    };

  latestDrv = mk sources.version "GE-Proton";

  majorTags = lib.filter (tag: buildableHere allReleases.${tag}) (lib.attrNames allReleases);
  majorChannels = lib.listToAttrs (
    map (tag: {
      name = "v${majorOf tag}";
      value = mk tag "GE-Proton ${majorOf tag}";
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

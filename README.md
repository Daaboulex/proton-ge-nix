# proton-ge (Nix)

[GE-Proton](https://github.com/GloriousEggroll/proton-ge-custom) by
[GloriousEggroll](https://github.com/GloriousEggroll) is Valve's Proton with
additional patches for games Valve's builds do not cover yet. This flake
packages its prebuilt releases for NixOS, in the shape
`programs.steam.extraCompatPackages` takes. It follows upstream's releases
daily, for anyone who wants a new release without waiting for nixpkgs.

It provides packages for `x86_64-linux` and `aarch64-linux`. The flake's check
builds every release offered on the machine it runs on and confirms each one
carries its `proton` entry point and its Steam manifests. Nothing here starts
Steam or a game, so whether a release runs a given game is untested.

## What you get

- `proton-ge` is the build for the machine's own architecture, x86_64 or
  aarch64. It is also the flake's default package.
- `proton-ge-x86_64` is the x86_64 build on either architecture, for an x86
  Steam client running under FEX on aarch64. On an x86_64 machine it is the
  same package as `proton-ge`.

## Install

Add the flake:

```nix
{
  inputs.proton-ge = {
    url = "github:Daaboulex/proton-ge-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then apply the overlay and hand the package to Steam:

```nix
{
  nixpkgs.overlays = [ inputs.proton-ge.overlays.default ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge ];
  };
}
```

Without the overlay, the same package is
`inputs.proton-ge.packages.${pkgs.stdenv.hostPlatform.system}.default`.

Steam lists it in each game's Compatibility dropdown.

## Choosing a release

`pkgs.proton-ge` follows upstream's newest release. The major lines are
channels on the same attribute, never packages of their own:

```nix
programs.steam.extraCompatPackages = [
  pkgs.proton-ge
  pkgs.proton-ge.v10
];
```

| Channel | What it is |
|---|---|
| `latest` | upstream's newest release, the same as the attribute alone |
| `v<major>` of the line upstream is still releasing | the newest release of that line |
| `v<major>` of a line upstream has closed | the last release of that line |

Which releases those are today is in [sources.nix](sources.nix), which the
daily updater moves.

The dropdown shows `GE-Proton <major> (<release>, latest)` for `latest` and
`GE-Proton <major> (<release>)` for a line, so the name says which release
runs. A game keeps its choice through every update. The choice is also the
same for the aarch64 build and the x86_64 build on one Steam root.

When upstream opens a new major, the updater keeps the outgoing line as a
channel by itself, so no channel vanishes.

## Known limits

- On `aarch64-linux`, `proton-ge` carries `latest` and `v11` only, because
  upstream ships an aarch64 build since GE-Proton11-1. The older lines exist
  on `proton-ge-x86_64` alone.
- The pre-2022 releases tagged `Proton-X.Y-GE-N` (4.x to 7.3) are not
  packaged.

## More

- [docs/DESIGN.md](docs/DESIGN.md): why it exists beside nixpkgs' own
  `proton-ge-bin`, how the channels work, the two names Steam sees
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md): building, the checks, how the
  updater moves the releases
- [SECURITY.md](SECURITY.md): how to report a security problem

## License

The packaging is MIT. GE-Proton itself is upstream's license (Valve Proton BSD-3-Clause lineage plus bundled components); this flake redistributes nothing - tarballs are fetched from upstream's GitHub releases at build time.

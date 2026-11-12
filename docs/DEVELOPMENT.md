# Development

```bash
nix build .#proton-ge
nix flake check
```

The flake's `nixpkgs` input follows `nixos-unstable`. CI runs from
[`.github/workflows/ci.yml`](../.github/workflows/ci.yml).

## Checks

`checks.compat-tool-shape` builds every channel of every tool attribute the
host has and reads each vdf for the key and display formats. It also refuses a
tool without a `proton` entry point or a `toolmanifest.vdf`, an architecture
or build-type word in a key or a display name, a pinned channel that shows
`latest`, and one key naming two tools of the same system.

`checks.overlay-applies` fails when a tool or one of its channels reached
through `overlays.default` differs from the flake's own packages.

## Updates

The rolling release, the pinned releases and the asset hashes of each are in
[`sources.nix`](../sources.nix). The daily updater,
[`.github/workflows/update.yml`](../.github/workflows/update.yml), moves that
file, configured by [`.github/update.json`](../.github/update.json).

The updater writes between the `# std:` markers in `sources.nix`. With
`majorPattern` set it refuses to move to a new major when the rolling or the
pins markers are missing.

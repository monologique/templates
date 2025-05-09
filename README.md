# monologique's flake templates

[![built with nix][nix-badge]][nix-url]
[![License: MIT][license-badge]][license-url]

[nix-badge]: https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a
[nix-url]: https://builtwithnix.org
[license-badge]: https://img.shields.io/badge/License-MIT-yellow.svg
[license-url]: https://opensource.org/licenses/MIT

## Getting Started

```bash
# In the current directory
nix flake init -t github:monologique/templates#flake

# In a new directory
nix flake new my-new-template -t github:monologique/templates#flake
```


## Registry Setup (For Frequent Use)

1. Add to your Nix registry

```bash
nix registry add monologique github:monologique/templates
```

2. Initialize the template

```bash
# In the current directory
nix flake init -t monologique#flake

# In a new directory
nix flake new /tmp/project-directory -t monologique#flake
```

## Contributing

PRs welcome! Please:

- Maintain existing formatting standards (nix flake check).
- Update documentation accordingly.

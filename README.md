## Prerequisites
Skip this is you already have `nix` and/or `direnv` installed.
# Install nix
Follow the guide [here](https://nixos.org/download#)

# Install nix-direnv
Follow the guide [here](git@github.com:nix-community/nix-direnv.git)

## Use this flake
# Add to your repository

```bash
nix registry add flakies git+https://git.earth2077.fr/leana/flakies
```

# Generate from the templates
```bash
nix flake init flakies#[query] # replace query with your module of liking
```

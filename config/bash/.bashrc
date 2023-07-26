# starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Rust
. "$HOME/.cargo/env"

eval "$(starship init bash)"
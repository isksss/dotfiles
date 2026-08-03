# Use the same Starship prompt as the other interactive shells.
(( $+commands[starship] )) && eval "$(starship init zsh)"

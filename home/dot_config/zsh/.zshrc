# Interactive shell entrypoint. Keep the load order explicit.
for config in \
	"$ZDOTDIR/rc/10-options.zsh" \
	"$ZDOTDIR/rc/20-plugins.zsh" \
	"$ZDOTDIR/rc/30-completion.zsh" \
	"$ZDOTDIR/rc/40-abbreviations.zsh" \
	"$ZDOTDIR/rc/50-functions.zsh" \
	"$ZDOTDIR/rc/60-integrations.zsh" \
	"$ZDOTDIR/rc/70-prompt.zsh" \
	"$ZDOTDIR/rc/90-local.zsh"; do
	[[ -r "$config" ]] && source "$config"
done

unset config

#!/usr/bin/env bash
if [ -f "$HOME/env.sh" ]; then
    source "$HOME/env.sh"
fi
today=$(date '+%Y%m%d_%H%M%S')
zip_file="${ISKSSS_HOME}/dotfiles.${today}.zip"
target="${DOTFILES_PATH}"
echo "target: ${DOTFILES_PATH}"
7z a "$zip_file" "$target" -xr!dotfiles.*.zip

echo "${zip_file}"

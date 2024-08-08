if [ -z "$(ls $XDG_CONFIG_HOME/bash/local.d/)" ]; then
    touch ls $XDG_CONFIG_HOME/bash/local.d/local.sh
fi
for script in "$XDG_CONFIG_HOME/bash/local.d/*.sh"; do
    source $script
done
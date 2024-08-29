for script in "$XDG_CONFIG_HOME/bash/local.d/*.sh"; do
    source $script
done
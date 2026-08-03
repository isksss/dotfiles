# XDG base directories and user executables.
$env.XDG_CONFIG_HOME = ($env.XDG_CONFIG_HOME? | default ($env.HOME | path join ".config"))
$env.XDG_CACHE_HOME = ($env.XDG_CACHE_HOME? | default ($env.HOME | path join ".cache"))
$env.XDG_DATA_HOME = ($env.XDG_DATA_HOME? | default ($env.HOME | path join ".local" "share"))
$env.XDG_STATE_HOME = ($env.XDG_STATE_HOME? | default ($env.HOME | path join ".local" "state"))

$env.PATH = (
    $env.PATH
    | prepend ($env.HOME | path join ".local" "bin")
    | prepend ($env.HOME | path join ".local" "share" "mise" "shims")
    | uniq
)

# Generate shell integration scripts before config.nu is loaded. Keeping these in
# the cache avoids committing paths that are specific to one machine.
let integration_dir = ($env.XDG_CACHE_HOME | path join "nushell" "integrations")
mkdir $integration_dir

if (which mise | is-not-empty) {
    ^mise activate nu | save --force ($integration_dir | path join "mise.nu")
} else {
    "" | save --force ($integration_dir | path join "mise.nu")
}

if (which starship | is-not-empty) {
    ^starship init nu | save --force ($integration_dir | path join "starship.nu")
} else {
    "" | save --force ($integration_dir | path join "starship.nu")
}

if (which zoxide | is-not-empty) {
    ^zoxide init nushell --cmd cd | save --force ($integration_dir | path join "zoxide.nu")
} else {
    "" | save --force ($integration_dir | path join "zoxide.nu")
}

if (which atuin | is-not-empty) {
    ^atuin init nu | save --force ($integration_dir | path join "atuin.nu")
} else {
    "" | save --force ($integration_dir | path join "atuin.nu")
}

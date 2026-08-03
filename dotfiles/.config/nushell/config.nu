$env.config = ($env.config | merge {
    show_banner: false
    edit_mode: emacs
    buffer_editor: "nvim"
    history: {
        file_format: sqlite
        max_size: 100_000
        sync_on_enter: true
        isolation: false
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: fuzzy
        use_ls_colors: true
    }
    abbreviations: {
        re: "exec nu --login"
        "..": "cd .."
        n: "nvim"
        ls: "eza"
        la: "eza -a"
        ll: "eza -l"
        lla: "eza -la"
        cat: "bat"
        lg: "lazygit"
        yz: "yazi"
        d: "docker"
        dc: "docker compose"
        dce: "docker compose exec"
        dps: "docker ps"
        di: "docker images"
        dcd: "docker compose down -v"
        dcup: "docker compose up -d"
        ldc: "lazydocker"
        zl: "zellij"
        oc: "opencode"
    }
})

source ($nu.cache-dir | path join "integrations" "mise.nu")
source ($nu.cache-dir | path join "integrations" "zoxide.nu")
source ($nu.cache-dir | path join "integrations" "atuin.nu")
source ($nu.cache-dir | path join "integrations" "starship.nu")

def nuls [path?: glob] {
    if $path == null {
        ls
    } else {
        ls $path
    }
}

def --env ccd [] {
    cd ($env.HOME | path join "dotfiles")
}

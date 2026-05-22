Import-Module PSReadLine
mise activate pwsh | Out-String | Invoke-Expression
mise completion powershell | Out-String | Invoke-Expression
function re {
    $profilePath = $PROFILE
    if (Test-Path -Path $profilePath) {
        . $profilePath
        Write-Host "Profile reloaded from $profilePath"
    }
    else {
        Write-Warning "Profile file not found at $profilePath"
    }
}

function Get-GhqPath {
    ghq list --full-path | fzf
}

function dev {
    $moveto = Get-GhqPath
    if ([string]::IsNullOrWhiteSpace($moveto)) {
        return
    }
    Set-Location $moveto
}

function Update-ZellijTabName {
    if (-not $env:ZELLIJ) {
        return
    }

    $repo = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -eq 0 -and $repo) {
        $repo = Split-Path $repo -Leaf
        $repo = $repo -replace "=.*$", ""

        $branch = git branch --show-current 2>$null

        if ($branch) {
            zellij action rename-tab "$repo`:$branch" *> $null
        }
        else {
            zellij action rename-tab (Split-Path (Get-Location) -Leaf) *> $null
        }
    }
    else {
        zellij action rename-tab (Split-Path (Get-Location) -Leaf) *> $null
    }
}

# function prompt {
#     Update-ZellijTabName
#     "PS $($executionContext.SessionState.Path.CurrentLocation)> "
# }

Update-ZellijTabName

$env:XDG_CONFIG_HOME = "$env:USERPROFILE\.config"
$env:XDG_CACHE_HOME = "$env:USERPROFILE\.cache"
$env:XDG_DATA_HOME = "$env:USERPROFILE\.local\share"
$env:XDG_STATE_HOME = "$env:USERPROFILE\.local\state"

$env:SHELL = "pwsh"
$env:ZELLIJ_CONFIG_DIR = "$env:XDG_CONFIG_HOME\zellij"

gwq completion powershell | Out-String | Invoke-Expression

# starship
Invoke-Expression (&starship init powershell)

# docker
Import-Module DockerCompletion

Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

# abbreviation
Import-Module "$HOME/.config/pwsh/modules/abbr-pwsh"

Set-Abbr dc "docker compose"
Set-Abbr dce "docker compose exec"
Set-Abbr dcup "docker compose up"
Set-Abbr dcd "docker compose down"
Set-Abbr dcreload "docker compose restart"

Set-Abbr ls eza
Set-Abbr la "eza -a"
Set-Abbr ll "eza -l"
Set-Abbr lla "eza -la"

Set-Abbr ".." "cd .."

Set-Abbr cat "bat"

Set-Abbr zl "zellij"

Set-Abbr lg "lazygit"

Set-Abbr winup "sudo winget upgrade --all --accept-source-agreements --accept-package-agreements"

# $HOME\.config\pwsh\{000...999}_{example}.ps1を読み込む
Get-ChildItem -Path "$HOME\.config\pwsh\*_*.ps1" -File | ForEach-Object {
    . $_.FullName
}

# .local.ps1
if (Test-Path -Path "$HOME\.config\pwsh\.local.ps1") {
    . "$HOME\.config\pwsh\.local.ps1"
}

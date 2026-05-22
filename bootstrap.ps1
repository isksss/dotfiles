$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoUrl = if ($env:DOTFILES_REPO_URL) {
    $env:DOTFILES_REPO_URL
}
else {
    'https://github.com/isksss/dotfiles.git'
}

$DotfilesDir = if ($env:DOTFILES_DIR) {
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($env:DOTFILES_DIR)
}
else {
    Join-Path $HOME 'dotfiles'
}

function Write-Log {
    param([Parameter(Mandatory)][string]$Message)

    Write-Host $Message
}

function Stop-Bootstrap {
    param([Parameter(Mandatory)][string]$Message)

    throw "bootstrap: $Message"
}

function Assert-LastExitCode {
    param([Parameter(Mandatory)][string]$Command)

    if ($LASTEXITCODE -ne 0) {
        Stop-Bootstrap "$Command failed with exit code $LASTEXITCODE."
    }
}

function Test-Command {
    param([Parameter(Mandatory)][string]$Name)

    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Update-SessionPath {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = @($machinePath, $userPath, $env:Path) -join ';'
}

function Get-MiseCommand {
    $command = Get-Command mise -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    $scoopShim = Join-Path $HOME 'scoop\shims\mise.exe'
    if (Test-Path -LiteralPath $scoopShim) {
        return $scoopShim
    }

    return $null
}

function Install-Mise {
    $mise = Get-MiseCommand
    if ($mise) {
        return $mise
    }

    if (Test-Command scoop) {
        Write-Log 'Installing mise with Scoop...'
        & scoop install mise
        Assert-LastExitCode 'scoop install mise'
    }
    elseif (Test-Command winget) {
        Write-Log 'Installing mise with winget...'
        & winget install --id jdx.mise --exact --accept-package-agreements --accept-source-agreements
        Assert-LastExitCode 'winget install jdx.mise'
    }
    else {
        Stop-Bootstrap 'mise is missing. Install Scoop or winget, then run this script again.'
    }

    Update-SessionPath
    $mise = Get-MiseCommand
    if (-not $mise) {
        Stop-Bootstrap 'mise was installed but is not available in this PowerShell session.'
    }

    return $mise
}

function Assert-Git {
    if (-not (Test-Command git)) {
        Stop-Bootstrap "'git' is required."
    }
}

function Test-SameRepository {
    $remoteUrl = & git -C $DotfilesDir config --get remote.origin.url 2>$null
    return $remoteUrl -in @(
        $RepoUrl,
        'https://github.com/isksss/dotfiles',
        'git@github.com:isksss/dotfiles.git',
        'ssh://git@github.com/isksss/dotfiles.git'
    )
}

function Get-DotfilesRepository {
    if (Test-Path -LiteralPath $DotfilesDir) {
        $gitDir = Join-Path $DotfilesDir '.git'
        if (-not (Test-Path -LiteralPath $gitDir -PathType Container)) {
            Stop-Bootstrap "$DotfilesDir already exists and is not a Git checkout."
        }

        if (-not (Test-SameRepository)) {
            Stop-Bootstrap "$DotfilesDir already exists and origin is not $RepoUrl."
        }

        Write-Log "Using existing checkout: $DotfilesDir"
        return
    }

    $parentDir = Split-Path -Parent $DotfilesDir
    if ($parentDir) {
        New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    }

    Write-Log "Cloning $RepoUrl into $DotfilesDir..."
    & git clone $RepoUrl $DotfilesDir
    Assert-LastExitCode 'git clone'
}

function Invoke-Dotfiles {
    param([Parameter(ValueFromRemainingArguments)][string[]]$Arguments)

    & $script:MiseCommand exec 'go@latest' 'go:github.com/rhysd/dotfiles@latest' -- dotfiles @Arguments
    Assert-LastExitCode 'mise exec dotfiles'
}

Assert-Git
$script:MiseCommand = Install-Mise
Get-DotfilesRepository

Push-Location $DotfilesDir
try {
    Write-Log 'Trusting mise config...'
    & $script:MiseCommand trust (Join-Path $DotfilesDir 'mise.toml')
    Assert-LastExitCode 'mise trust'

    Write-Log 'Previewing dotfile links...'
    Invoke-Dotfiles link --dry

    Write-Log 'Linking dotfiles...'
    Invoke-Dotfiles link

    Write-Log 'Installing tools from mise.toml...'
    & $script:MiseCommand install
    Assert-LastExitCode 'mise install'
}
finally {
    Pop-Location
}

Write-Log "Bootstrap complete: $DotfilesDir"

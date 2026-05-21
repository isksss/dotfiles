mise activate pwsh | Out-String | Invoke-Expression

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
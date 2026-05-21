$global:Abbreviations = @{}

function Set-Abbr {
    param(
        [string]$Name,
        [string]$Expansion
    )

    $global:Abbreviations[$Name] = $Expansion
}

Set-PSReadLineKeyHandler -Chord Spacebar -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null

    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState(
        [ref]$line,
        [ref]$cursor
    )

    $word = ($line.Substring(0, $cursor) -split '\s+')[-1]

    if ($global:Abbreviations.ContainsKey($word)) {
        $expanded = $global:Abbreviations[$word]

        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
            $cursor - $word.Length,
            $word.Length,
            $expanded
        )

        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(' ')
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(' ')
    }
}

Export-ModuleMember -Function Set-Abbr

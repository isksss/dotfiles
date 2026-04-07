# mise が存在するかチェック
if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
    Write-Host "mise not found. Installing..."

    # 公式インストール（PowerShell版）
    iwr https://mise.run/install.ps1 -UseBasicParsing | iex

    Write-Host "mise installed."
}
# win script
# sample script.
$ENV:PATH.Split(";")

# nvim 

# ↓要管理者権限
# New-Item -Value $env:DOTFILES\.config\nvim -Path $env:HOME\.config\nvim -Name nvim -ItemType SymbolicLink
# いったんファイルコピーで対応

## フォルダ作成
$nvimconfig = $env:HOME\.config\nvim
if($result){
    Remove-Item -Path $nvimconfig
}
New-Item $nvimconfig -ItemType Directory

## COPY
Copy-Item -Path $env:DOTFILES\.config\nvim\* -Destination $env:HOME\.config\nvim\

$result = (Test-Path $nvimconfig)
 

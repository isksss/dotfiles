#==================================================
# environment
#==================================================
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

#===== private =====#
$ENV:LOCAL_BIN = "$ENV:USERPROFILE\.local\bin"
$ENV:HOME = "$ENV:USERPROFILE"
$ENV:SHELL = "powershell"

#===== xdg =====#
$ENV:XDG_CONFIG_HOME = "$ENV:HOME\.config"
$ENV:XDG_DATA_HOME = "$ENV:HOME\.local\share"
$ENV:XDG_CACHE_HOME = "$ENV:HOME\.cache"
$ENV:XDG_STATE_HOME = "$ENV:HOME\.local\state"

#==================================================
# function
#==================================================

# whichコマンド
function which($cmdname) {
  Get-Command $cmdname | Select-Object -ExpandProperty Definition
}

# コマンド存在確認
function isCmdExists($cmdname) {
  if (Get-Command $cmdname -ea SilentlyContinue) {
    return $true
  }
  else {
    return $false
  }
}

# パス追加
function addPath() {
  param(
    [string] $path
  )
  $ENV:Path = "$path;" + $ENV:Path
}

#==================================================
# path
#==================================================
addPath -path "$ENV:LOCAL_BIN"

#==================================================
# alias
#==================================================

# clear
Set-Alias cl clear

function re () {
  . $profile
}

#==================================================
# prompt
#==================================================
if (Get-Command "starship " -ea SilentlyContinue) {
  Invoke-Expression (&starship init powershell)
}

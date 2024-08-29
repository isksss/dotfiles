#==================================================
# environment
#==================================================
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

#===== private =====#
$ENV:WORKSPACE = "$ENV:USERPROFILE\workspace"
$ENV:LOCAL_BIN = "$ENV:USERPROFILE\.local\bin"
$ENV:HOME="$ENV:USERPROFILE"

#===== xdg =====#
$ENV:XDG_CONFIG_HOME = "$ENV:USERPROFILE\.config"
$ENV:XDG_DATA_HOME = "$ENV:USERPROFILE\.local\share"
$ENV:XDG_CACHE_HOME = "$ENV:USERPROFILE\.cache"
$ENV:XDG_STATE_HOME = "$ENV:USERPROFILE\.local\state"

#==================================================
# function
#==================================================

# whichコマンド
function which($cmdname) {
  Get-Command $cmdname | Select-Object -ExpandProperty Definition
}

# コマンド存在確認
function isCmdExists($cmdname){
  if (Get-Command $cmdname -ea SilentlyContinue) {
    return $true
  } else {
    return $false
  }
}

# パス追加
function addPath(){
  param(
    [string] $path
  )
  $ENV:Path="$path;"+$ENV:Path
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

# cd
function customCdParent() { Set-Location -Path ".." }
function customCdWorkspace() { Set-Location -Path "$ENV:WORKSPACE" }
function customCdDotfiles() { Set-Location -Path "$ENV:WORKSPACE\dotfiles" }
function customCdDevelop() { Set-Location -Path "$ENV:WORKSPACE\develop" }
Set-Alias ".." customCdParent
Set-Alias "c-workspace" customCdWorkspace
Set-Alias "c-dotfiles" customCdDotfiles
Set-Alias "c-develop" customCdDevelop

#==================================================
# prompt
#==================================================
function prompt() {
  $username = $env:UserName
  $computername = $env:ComputerName.ToLower()
  $drive = $pwd.Drive.Name
  $path = $pwd.path.Replace($ENV:HOME, "~").Replace("${drive}:", "")

  Write-Host "$username@$computername" -ForegroundColor "DarkGreen" -NoNewLine
  Write-Host ":" -NoNewLine
  Write-Host "$path" -ForegroundColor "DarkBlue"

  Write-Host "$" -ForegroundColor "DarkGreen" -NoNewLine

  return " "
}

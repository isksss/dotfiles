##
Set-ExecutionPolicy Bypass -Scope CurrentUser

## windows script
$ENV:DOTFILES = $MyInvocation.MyCommand.Path
$ENV:DOTFILES = Split-Path -Parent $ENV:DOTFILES

## profile
$ENV:PROFILE = "$ENV:DOTFILES\powershell\profile.ps1"

& $ENV:PROFILE

## scoop
# powershell -File $ENV:DOTFILES\installer\win\scoop.ps1

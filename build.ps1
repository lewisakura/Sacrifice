# This script will most likely only work with PowerShell Core.

$LoveExe = "C:\Program Files\LOVE\love.exe"
$Ignored = Get-Content .buildignore

if (Test-Path build) { Remove-Item -Recurse build/ }

New-Item -ItemType Directory -Path build | Out-Null

Get-ChildItem -Path . -Exclude $Ignored | Compress-Archive -DestinationPath build/sacrifice.love
Get-Content $LoveExe, build/sacrifice.love -Read 512 -AsByteStream | Set-Content build/sacrifice.exe -AsByteStream
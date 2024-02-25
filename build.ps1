New-Item -ItemType Directory -Path "$PSScriptRoot\bin" -Force | Out-Null

& "$PSScriptRoot\src\markdown\build.ps1"
& "$PSScriptRoot\src\greeter\build.ps1"
& "$PSScriptRoot\src\host\build.ps1"


wit-bindgen.exe c-sharp --runtime native-aot --world markdown "$PSScriptRoot\..\..\wit\platform.wit" --out-dir "$PSScriptRoot\wit-bindgen"

Write-Output "Building markdown module"
dotnet build -c Release

Write-Output "Linking markdown module as a component"
wasm-tools component new `
    "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\markdown.wasm" `
    -o "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\markdown-component.wasm" `
    --adapt "$PSScriptRoot\..\..\tools\wasi-adapters\18.0.1\wasi_snapshot_preview1.reactor.wasm"

New-Item -ItemType Directory -Path "$PSScriptRoot\..\..\bin" -Force
Copy-Item "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\markdown-component.wasm" -Destination "$PSScriptRoot\..\..\bin\markdown.wasm"
Write-Output "Done"

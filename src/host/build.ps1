wit-bindgen.exe c-sharp --runtime native-aot --world host "$PSScriptRoot\..\..\wit\platform.wit" --out-dir "$PSScriptRoot\wit-bindgen"

Write-Output "Building host module"
dotnet build "$PSScriptRoot\host.csproj" -c Release

Write-Output "Linking host module as a component and composing with greeter dependency"
wasm-tools component new `
    "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\host.wasm" `
    -o "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\host-component.wasm" `
    --adapt "$PSScriptRoot\..\..\tools\wasi-adapters\18.0.1\wasi_snapshot_preview1.command.wasm"

wasm-tools compose `
    -o "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\host-composite.wasm" `
    "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\host-component.wasm" `
    -d "$PSScriptRoot\..\..\bin\greeter.wasm"
    
Copy-Item "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\host-composite.wasm" -Destination "$PSScriptRoot\..\..\bin\host.wasm"
Write-Output "Done"

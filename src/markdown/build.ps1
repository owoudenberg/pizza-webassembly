wit-bindgen.exe c-sharp --runtime native-aot --world markdown "$PSScriptRoot\..\..\wit\platform.wit" --out-dir "$PSScriptRoot\wit-bindgen"
dotnet build -c Release
wasm-tools component new `
    "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\markdown.wasm" `
    -o "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\markdown.component.wasm" `
    --adapt "$PSScriptRoot\..\..\tools\wasi-adapters\18.0.1\wasi_snapshot_preview1.reactor.wasm"

wasm-tools component wit `
    "$PSScriptRoot\bin\Release\net8.0\wasi-wasm\native\markdown.component.wasm"
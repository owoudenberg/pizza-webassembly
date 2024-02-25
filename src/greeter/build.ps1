wit-bindgen c "$PSScriptRoot\..\..\wit\platform.wit" --world greeter

New-Item -ItemType Directory -Path bin -Force | Out-Null

clang component.c greeter_component_type.o greeter.c -o ./bin/greeter.wasm -mexec-model=reactor

wasm-tools component new "$PSScriptRoot\bin\greeter.wasm" `
    -o "$PSScriptRoot\bin\greeter.component.wasm" `
    --adapt "$PSScriptRoot\..\..\tools\wasi-adapters\18.0.1\wasi_snapshot_preview1.reactor.wasm"
wasm-tools component wit ./bin/greeter.component.wasm
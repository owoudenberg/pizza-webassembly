wit-bindgen c "$PSScriptRoot\..\..\wit\platform.wit" --world greeter

'obj', 'bin' | ForEach-Object { New-Item -ItemType Directory -Path "$PSScriptRoot\$_" -Force } | Out-Null

Write-Output "Building greeter module"
clang -Wall -Wextra -Werror -Wno-unused-parameter -c -o "$PSScriptRoot\obj\greeter.o" "$PSScriptRoot\greeter.c"
clang++ -Wall -Wextra -Werror -Wno-unused-parameter -c -o "$PSScriptRoot\obj\component.o" "$PSScriptRoot\component.cpp"
clang++ "$PSScriptRoot\obj\component.o" "$PSScriptRoot\obj\greeter.o" "$PSScriptRoot\greeter_component_type.o" -mexec-model=reactor -o "$PSScriptRoot\bin\greeter.wasm"

Write-Output "Linking greeter module as a component and composing with markdown dependency"
wasm-tools component new "$PSScriptRoot\bin\greeter.wasm" `
    -o "$PSScriptRoot\bin\greeter-component.wasm" `
    --adapt "$PSScriptRoot\..\..\tools\wasi-adapters\18.0.1\wasi_snapshot_preview1.reactor.wasm"

wasm-tools compose `
    -o "$PSScriptRoot\bin\greeter-composite.wasm" `
    "$PSScriptRoot\bin\greeter-component.wasm" `
    -d "$PSScriptRoot\..\..\bin\markdown.wasm"

Copy-Item "$PSScriptRoot\bin\greeter-composite.wasm" -Destination "$PSScriptRoot\..\..\bin\greeter.wasm"
Write-Output "Done"

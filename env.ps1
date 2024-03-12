# Tool versions
$wasiSdkVersion = "21.0"
$emscriptenSdkVersion = "3.1.54"
$wasmToolVersion = "1.200.0"
$wasmtimeVersion = "18.0.1"
$witBindgenVersion = "0.19.1"

$wasiSdkUrl = "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-$(($wasiSdkVersion -split '\.')[0])/wasi-sdk-$wasiSdkVersion.m-mingw.tar.gz"
$emscriptenSdkUrl = "https://github.com/emscripten-core/emsdk/archive/refs/tags/$emscriptenSdkVersion.zip"
$wasmToolsUrl = "https://github.com/bytecodealliance/wasm-tools/releases/download/v$wasmToolVersion/wasm-tools-$wasmToolVersion-x86_64-windows.zip"
$wasmtimeUrl = "https://github.com/bytecodealliance/wasmtime/releases/download/v$wasmtimeVersion/wasmtime-v$wasmtimeVersion-x86_64-windows.zip"
$wasmtimeAdaptersUrl = "https://github.com/bytecodealliance/wasmtime/releases/download/v$wasmtimeVersion/"
$witBindgenUrl = "https://github.com/bytecodealliance/wit-bindgen/releases/download/v$witBindgenVersion/wit-bindgen-$witBindgenVersion-x86_64-windows.zip"


function Download-File {
    param (
        [string]$Url,
        [string]$DestinationFolder
    )

    $client = New-Object System.Net.WebClient

    try {
        $filename = [System.IO.Path]::GetFileName($Url);

        $destinationPath = Join-Path -Path $DestinationFolder -ChildPath $filename

        $client.DownloadFile($Url, $destinationPath)

        return $destinationPath
    }
    catch {
        Write-Error "An error occurred while downloading the file: $_"
        return $null
    }
    finally {
        $client.Dispose()
    }
}

function Add-Path($Path) {
    if ($env:PATH -notlike "*$path*") {
        $env:PATH += [IO.Path]::PathSeparator + $Path
    }
}

# Download and install tools
$downloadFolder = "./.tmp"
$toolsFolder = "./tools"

New-Item -ItemType Directory -Path $downloadFolder -Force | Out-Null

# Install wasm-tools if not already installed
$wasmtoolsRoot = "$toolsFolder/wasm-tools/$wasmToolVersion"
if (-not (Test-Path $wasmtoolsRoot)) {
    Write-Output "Downloading and extracting wasm-tools to $wasmtoolsRoot"
    $wasmtoolsDownload = Download-File $wasmToolsUrl $downloadFolder
    New-Item -ItemType Directory -Path $wasmtoolsRoot -Force | Out-Null
    tar -xf "$wasmtoolsDownload" -C "$wasmtoolsRoot" --strip-components=1
}
Add-Path ("$wasmtoolsRoot" | Resolve-Path)


#Install wasmtime if not already installed
$wasmtimeRoot = "$toolsFolder/wasmtime/$wasmtimeVersion"
if (-not (Test-Path $wasmtimeRoot)) {
    Write-Output "Downloading and extracting wasmtime to $wasmtimeRoot"
    $wasmtimeDownload = Download-File $wasmtimeUrl $downloadFolder
    New-Item -ItemType Directory -Path $wasmtimeRoot -Force | Out-Null
    tar -xf "$wasmtimeDownload" -C "$wasmtimeRoot" --strip-components=1
}
Add-Path ("$wasmtimeRoot" | Resolve-Path)

#Install wasmtime adapters if not already installed
$wasmtimeAdaptersRoot = "$toolsFolder/wasi-adapters/$wasmtimeVersion"
if (-not (Test-Path $wasmtimeAdaptersRoot)) {
    Write-Output "Downloading and extracting wasmtime adapters to $wasmtimeAdaptersRoot"
    New-Item -ItemType Directory -Path $wasmtimeAdaptersRoot -Force | Out-Null
    Download-File "$wasmtimeAdaptersUrl/wasi_snapshot_preview1.command.wasm" $wasmtimeAdaptersRoot | Out-Null
    Download-File "$wasmtimeAdaptersUrl/wasi_snapshot_preview1.reactor.wasm" $wasmtimeAdaptersRoot | Out-Null
}

# Install wasi-sdk if not already installed
$wasiSdkRoot = "$toolsFolder/wasi-sdk/$wasSdkVersion"
if (-not (Test-Path $wasiSdkRoot)) {
    Write-Output "Downloading and extracting wasi-sdk to $wasiSdkRoot"
    $wasiSdkDownload = Download-File $wasiSdkUrl $downloadFolder
    New-Item -ItemType Directory -Path $wasiSdkRoot -Force | Out-Null
    tar -xf "$wasiSdkDownload" -C "$wasiSdkRoot" --strip-components=1
}
Add-Path ("$wasiSdkRoot\bin" | Resolve-Path)
$env:WASI_SDK_PATH = ("$wasiSdkRoot" | Resolve-Path)

# Install emscripten-sdk if not already installed
$emscriptenSdkRoot = "$toolsFolder/emsdk/$emscriptenSdkVersion"
if (-not (Test-Path $emscriptenSdkRoot)) {
    Write-Output "Downloading and extracting emsdk to $emscriptenSdkRoot"
    $emscriptenSdkDownload = Download-File $emscriptenSdkUrl $downloadFolder
    New-Item -ItemType Directory -Path $emscriptenSdkRoot -Force | Out-Null
    tar -xf "$emscriptenSdkDownload" -C "$emscriptenSdkRoot" --strip-components=1
    & "$emscriptenSdkRoot\emsdk" install $emscriptenSdkVersion
    & "$emscriptenSdkRoot\emsdk" activate $emscriptenSdkVersion
}

# Install wasi-sdk if not already installed
$witBindgenSdkRoot = "$toolsFolder/wit-bindgen/$witBindgenVersion"
if (-not (Test-Path $witBindgenSdkRoot)) {
    Write-Output "Downloading and extracting wit-bindgen to $witBindgenSdkRoot"
    $witBindgetDownload = Download-File $witBindgenUrl $downloadFolder
    New-Item -ItemType Directory -Path $witBindgenSdkRoot -Force | Out-Null
    tar -xf "$witBindgetDownload" -C "$witBindgenSdkRoot" --strip-components=1
}
Add-Path ("$witBindgenSdkRoot" | Resolve-Path)

#Install rust if not already installed
if (-not (Test-Path "$($env:USERPROFILE)\.cargo")) {
    $rustup = Download-File "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-gnu/rustup-init.exe" $downloadFolder
    & "$rustup" --quiet -y --default-host x86_64-pc-windows-gnu --default-toolchain stable --profile minimal
}
Add-Path ("$($env:USERPROFILE)\.cargo\bin" | Resolve-Path)
& "$($env:USERPROFILE)\.cargo\bin\rustup" target add wasm32-wasi

Remove-Item $downloadFolder -Recurse -ErrorAction Ignore
set windows-shell := ["cmd.exe", "/c"]

GO := "go"
GOFLAGS := "-v -a"
RELEASE_FLAGS := "-ldflags=-s -ldflags=-w"

BIN_EXT := if os() == "windows" { ".exe" } else { "" }
BIN_NAME := "echo" + BIN_EXT

PORT := "2323"
BUILD_DIR := "build"

# Build the project
[arg("build_type", long="build-type", pattern="debug|release")]
@build build_type="debug":
    just build-internal {{build_type}}

[private]
[windows]
build-internal build_type:
    #!powershell -NoProfile

    $flags = if ("{{build_type}}" -eq "release") { "{{GOFLAGS}} {{RELEASE_FLAGS}}" } else { "{{GOFLAGS}}" }
    $out = "{{BUILD_DIR}}/{{build_type}}/{{BIN_NAME}}"

    $total = (go list -deps ./... | Measure-Object -Line).Lines

    Write-Host -ForegroundColor DarkGray "Starting build process ($total packages)..."

    $count = 0

    $cmd = "{{GO}} build $flags -o $out ./src 2>&1"

    Invoke-Expression $cmd | ForEach-Object {
        $count++

        $percent = [math]::Min([math]::Floor(($count / $total) * 100), 100)

        $pctStr = "{0,3}" -f $percent

        Write-Host -NoNewline -ForegroundColor Cyan "[$pctStr%] "
        Write-Host "Compiling $_"
    }
    
    Write-Host -ForegroundColor Green "[100%] Build Complete!"

[private]
[unix]
build-internal build_type:
    #!/usr/bin/env bash

    if [ "{{build_type}}" = "release" ]; then
        flags="{{GOFLAGS}} {{RELEASE_FLAGS}}"
    else
        flags="{{GOFLAGS}}"
    fi

    out="{{BUILD_DIR}}/{{build_type}}/{{BIN_NAME}}"

    total=$({{GO}} list -deps ./src | wc -l | tr -d ' ')

    printf "\033[90mStarting build process (%s packages)...\033[0m\n" "$total"

    count=0

    {{GO}} build $flags "$out" ./src 2>&1 | while read -r pkg; do
        count=$((count + 1))
        percent=$((count * 100 / total))

        if [ "$percent" -gt 100 ]; then percent=100; fi

        printf "\033[36m[%3d%%] \033[0mCompiling %s\n" "$percent" "$pkg"
    done

    printf "\033[32m[100%] Build Complete!\033[0m\n"

# Remove the build artifacts
clean: _clean-dir
    @echo Successfully removed build artifacts

[unix]
_clean-dir:
    @rm -rf {{BUILD_DIR}}

[windows]
_clean-dir:
    @if exist {{BUILD_DIR}} rmdir /s /q {{BUILD_DIR}}

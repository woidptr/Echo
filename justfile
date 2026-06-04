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
    {{ if build_type == "debug" { "just build-debug" } else { "just build-release" } }}

[private]
@build-debug:
    echo Compiling in debug...
    {{GO}} build {{GOFLAGS}} -o {{BUILD_DIR}}/debug/{{BIN_NAME}} ./src

[private]
@build-release:
    echo Compiling in release...
    {{GO}} build {{GOFLAGS}} {{RELEASE_FLAGS}} -o {{BUILD_DIR}}/release/{{BIN_NAME}} ./src

# Remove the build artifacts
clean: _clean-dir
    @echo Successfully removed build artifacts

[unix]
_clean-dir:
    @rm -rf {{BUILD_DIR}}

[windows]
_clean-dir:
    @if exist {{BUILD_DIR}} rmdir /s /q {{BUILD_DIR}}

set windows-shell := ["cmd.exe", "/c"]

BIN_EXT := if os() == "windows" { ".exe" } else { "" }
BIN_NAME := "echo" + BIN_EXT

PORT := "2323"
BUILD_DIR := "build"

# Build the project
build:
    go build -o {{BUILD_DIR}}/{{BIN_NAME}} ./src

# Remove the build artifacts
clean: _clean-dir
    @echo Successfully removed build artifacts

[unix]
_clean-dir:
    @rm -rf {{BUILD_DIR}}

[windows]
_clean-dir:
    @if exist {{BUILD_DIR}} rmdir /s /q {{BUILD_DIR}}

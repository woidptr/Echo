BIN_NAME := "echo"
PORT := "2323"
BUILD_DIR := "build"

default: build

build:
    go build -o {{BUILD_DIR}}/{{BIN_NAME}} ./src

clean:
    rm -rf {{BUILD_DIR}}

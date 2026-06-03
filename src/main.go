package main

import (
	"echo/src/server"
	"log"
)

func main() {
	if err := server.Start("2323"); err != nil {
		log.Fatalf("Server crashed: %v", err)
	}
}

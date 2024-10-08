package main

import (
	"fmt"
	"os"
)

func main() {
	fmt.Println("opm simulator")
	os.MkdirAll("/tmp/cache", 0755)
	json := "{ \"cache\":\"empty\" }"
	os.WriteFile("/tmp/cache/product.json", []byte(json), 0755)
}

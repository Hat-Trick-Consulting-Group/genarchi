package main

import (
	"fmt"
	"log"
	"net/http"

	_ "github.com/lib/pq"
)

const (
	host     = "localhost"
	port     = 5432
	user     = "admin"
	password = "admin"
	dbname   = "crm"
)

func main() {
	// Initialize the database connection
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)
	log.Printf("psqlInfo: %s", psqlInfo)
	db := InitDB(psqlInfo)

	// Create the "clients" table if it doesn't exist
	if err := createClientsTable(db); err != nil {
		log.Fatalf("Failed to create 'clients' table: %v", err)
	}

 	// Start the API server	
	port := "8080" // Change to your desired port
	log.Printf("Server started on :%s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	_ "github.com/lib/pq"
)

var db *sql.DB

func InitDB(dataSourceName string) (db *sql.DB)  {
    var err error
    db, err = sql.Open("postgres", dataSourceName)
    if err != nil {
        log.Fatalf("Failed to initialize database: %v", err)
    }

    err = db.Ping()
    if err != nil {
        log.Fatalf("Failed to ping database: %v", err)
    }

    return db
}

func createClientsTable(db *sql.DB) error {
	// SQL statement to create the table if it doesn't exist
	createTableSQL := `
		CREATE TABLE IF NOT EXISTS clients (
			id SERIAL PRIMARY KEY,
			name VARCHAR(255),
			email VARCHAR(255)
		);
	`

	// Execute the SQL statement
	_, err := db.Exec(createTableSQL)
	if err != nil {
        log.Printf("Sync table 'clients' : Error : %v", err)
		return err
	}

    log.Print("Sync table 'clients' : DONE")

	return nil
}

func createClientHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	var body client // Create an instance of the client struct

	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		http.Error(w, "Failed to parse request body", http.StatusBadRequest)
		return
	}
    
	// You should use prepared statements to prevent SQL injection
	_, err := db.Exec("INSERT INTO clients (name, email) VALUES ($1, $2)", body.Name, body.Email)
	if err != nil {
		http.Error(w, "Failed to insert client into the database", http.StatusInternalServerError)
		return
	}

	// Respond with a success message
	w.WriteHeader(http.StatusCreated)
    fmt.Fprintf(w, "Client created successfully: ID=%d, Name=%s, Email=%s", body.ID, body.Name, body.Email)
}

func getStatusHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodGet {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}
    w.WriteHeader(http.StatusOK)
    fmt.Fprintf(w, "API up")
}
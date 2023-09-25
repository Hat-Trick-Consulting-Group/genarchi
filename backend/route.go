package main

import (
	"database/sql"
	"log"

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
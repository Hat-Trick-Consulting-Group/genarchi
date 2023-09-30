package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

func InitDB(dataSourceName string) *sql.DB {
	db, err := sql.Open("postgres", dataSourceName)
	if err != nil {
		log.Fatalf("Failed to initialize database: %v", err)
	}

	err = db.Ping()
	if err != nil {
		log.Fatalf("Failed to ping database: %v", err)
	}

	return db
}

func CreateClientsTable(db *sql.DB) error {
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

func CreateClientHandler(c *gin.Context, db *sql.DB) {
	var newClient client

	if err := c.BindJSON(&newClient); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Failed to parse request body"})
		return
	}

	// Use a prepared statement to insert data safely
	safeQuery, err := db.Prepare("INSERT INTO clients (name, email) VALUES ($1, $2)")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to prepare SQL statement"})
		return
	}
	defer safeQuery.Close()

	_, err = safeQuery.Exec(newClient.Name, newClient.Email)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to insert client into the database"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": fmt.Sprintf("Client created successfully: Name=%s, Email=%s", newClient.Name, newClient.Email)})
}



func GetStatusHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "API up"})
}
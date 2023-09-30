package main

import (
	"fmt"
	"log"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

// PostgreSQL represents the database connection information
const (
	psql_host     = "localhost"
	psql_port     = 5432
	psql_user     = "admin"
	psql_password = "admin"
	psql_dbname   = "crm"
)

func main() {
	// Initialize the Gin router
	router := gin.Default()

	// Initialize the database connection
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		psql_host, psql_port, psql_user, psql_password, psql_dbname)
	fmt.Printf("psqlInfo: %s\n", psqlInfo)

	db := InitDB(psqlInfo)

	// Create the "clients" table if it doesn't exist
	if err := CreateClientsTable(db); err != nil {
		log.Fatalf("Failed to create 'clients' table: %v", err)
	}

	// Add routes to handle API requests
	router.GET("/health", GetStatusHandler)
	router.POST("/add-client", func(c *gin.Context) {
        CreateClientHandler(c, db)
    })
	router.GET("/get-clients", func(c *gin.Context) {
		GetClientsHandler(c, db)
	})


	// Start the API server
	port := "8080"
	log.Printf("Server started on :%s\n", port)
	log.Fatal(router.Run(":" + port))
}
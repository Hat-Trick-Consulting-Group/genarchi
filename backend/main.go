package main

import (
	"fmt"
	"log"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"

	"main/psql"
	"main/routes"
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

	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"*"} 
	router.Use(cors.New(config))

	// Initialize the database connection
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		psql_host, psql_port, psql_user, psql_password, psql_dbname)
	fmt.Printf("psqlInfo: %s\n", psqlInfo)

	db := psql.InitDB(psqlInfo)

	// Create the "clients" table if it doesn't exist
	if err := psql.CreateClientsTable(db); err != nil {
		log.Fatalf("Failed to create 'clients' table: %v", err)
	}

	// Add routes to handle API requests
	router.GET("/health", routes.GetStatusHandler)
	router.POST("/add-client", func(c *gin.Context) {
        routes.CreateClientHandler(c, db)
    })
	router.GET("/get-clients", func(c *gin.Context) {
		routes.GetClientsHandler(c, db)
	})
	router.PUT("/update-client", func(c *gin.Context) {
		routes.UpdateClientHandler(c, db)
	})
	router.DELETE("/delete-client", func(c *gin.Context) {
		routes.DeleteClientHandler(c, db)
	})


	// Start the API server
	port := "8080"
	log.Printf("Server started on :%s\n", port)
	log.Fatal(router.Run(":" + port))
}
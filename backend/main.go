package main

import (
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

// PostgreSQL represents the database connection information
func CORS() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}

func main() {
	env := os.Getenv("GO_ENV")
	var err error
	if "" == env {
		env = "development"
		err = godotenv.Load(".env.development")
	}
	if env == "production" {
		err = godotenv.Load(".env.production")	
	}

	if err != nil || env != "production" && env != "development" {
		log.Fatal("Error loading .env file, current environment: " + env)
	}

	log.Println("Environment: " + env)

	// Initialize the Gin router
	router := gin.Default()

	// config := cors.Default()
	// config.AllowOrigins = []string{"*"} 
	// config.AllowAllOrigins = true
	// router.Use(cors.New(config))
	router.Use(CORS())


	// // Create the "clients" table if it doesn't exist
	// if err := psql.CreateClientsTable(db); err != nil {
	// 	log.Fatalf("Failed to create 'clients' table: %v", err)
	// }

	// // Add routes to handle API requests
	// router.GET("/health", routes.GetStatusHandler)
	// router.POST("/add-client", func(c *gin.Context) {
    //     routes.CreateClientHandler(c, db)
    // })
	// router.GET("/get-clients", func(c *gin.Context) {
	// 	routes.GetClientsHandler(c, db)
	// })
	// router.PUT("/update-client", func(c *gin.Context) {
	// 	routes.UpdateClientHandler(c, db)
	// })
	// router.DELETE("/delete-client", func(c *gin.Context) {
	// 	routes.DeleteClientHandler(c, db)
	// })


	// Start the API server
	port := "8080"
	log.Printf("Server started on :%s\n", port)
	log.Fatal(router.Run(":" + port))
}
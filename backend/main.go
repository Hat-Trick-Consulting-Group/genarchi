package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"

	"main/routes"
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

const databaseName = "genarchi-p2"

func main() {
	var mongoClient *mongo.Client

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

	mongoURI := os.Getenv("MONGO_URI")
	if mongoURI == "" {
		fmt.Println("MONGO_URI environment variable is not set")
		return
	}

	log.Println("MONGO_URI: " + mongoURI)

	// Set up options
	clientOptions := options.Client().ApplyURI(mongoURI)

	// Loop until the MongoDB connection is successful
	for mongoClient == nil {
		// Attempt to connect to MongoDB
		mongoClient, err = mongo.Connect(context.Background(), clientOptions)

		if err != nil {
			log.Println("Error connecting to MongoDB:", err)
			log.Println("Retrying in 5 seconds...")
			time.Sleep(5 * time.Second)
		}

		// Check if the connection is alive by pinging the database
		err = mongoClient.Ping(context.Background(), nil)

		if err != nil {
			log.Println("Error pinging MongoDB:", err)
			log.Println("Retrying in 5 seconds...")
			mongoClient.Disconnect(context.Background())
			mongoClient = nil
			time.Sleep(5 * time.Second)
		}
	}

	fmt.Println("Connected to MongoDB!")

	// Initialize the Gin router
	router := gin.Default()

	router.Use(CORS())

	// // Create the "clients" table if it doesn't exist
	// if err := psql.CreateClientsTable(db); err != nil {
	// 	log.Fatalf("Failed to create 'clients' table: %v", err)
	// }

	// Add routes to handle API requests
	router.GET("/health", routes.GetStatusHandler)
	router.POST("/add-client", func(c *gin.Context) {
		routes.CreateClientHandler(c, mongoClient.Database(databaseName))
	})
	router.GET("/get-clients", func(c *gin.Context) {
		routes.GetClientsHandler(c, mongoClient.Database(databaseName))
	})
	router.PUT("/update-client", func(c *gin.Context) {
		routes.UpdateClientHandler(c, mongoClient.Database(databaseName))
	})
	router.DELETE("/delete-client", func(c *gin.Context) {
		routes.DeleteClientHandler(c, mongoClient.Database(databaseName))
	})

	// Start the API server
	port := "8080"
	log.Printf("Server started on :%s\n", port)
	log.Fatal(router.Run(":" + port))
}

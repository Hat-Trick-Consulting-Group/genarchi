package main

import (
	"context"
	// "fmt"
	"log"
	"os"
	// "strconv"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/bson"
    "go.mongodb.org/mongo-driver/mongo/options"

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

	// Define MongoDB connection options.
	clientOptions := options.Client().ApplyURI("mongodb://root:example_password@primary-mongo:27017,replica-mongo:27017/?replicaSet=rs0")

	// Create a MongoDB client.
	client, err := mongo.Connect(context.Background(), clientOptions)
	if err != nil {
		log.Fatal(err)
	}

	// Check if the client is connected to MongoDB.
	err = client.Ping(context.Background(), nil)
	if err != nil {
		log.Fatal(err)
	}

	log.Println("Connected to MongoDB")

	// You can now use the 'client' to interact with the MongoDB database.

	// Example: Create a new collection and insert a document.
	collection := client.Database("mydb").Collection("mycollection")
	_, err = collection.InsertOne(context.TODO(), bson.M{"key": "value"})
	if err != nil {
		log.Fatal(err)
	}

	// Close the MongoDB client when done.
	defer client.Disconnect(context.Background())

	// psql_host     := os.Getenv("PSQL_HOST")
	// psql_port, err    := strconv.Atoi(os.Getenv("PSQL_PORT"))
	// psql_user     := os.Getenv("PSQL_USER")
	// psql_password := os.Getenv("PSQL_PASSWORD")
	// psql_dbname   := os.Getenv("PSQL_DBNAME")
	
	// if err != nil {
	// 	log.Fatal("Error converting PSQL_PORT to int")
	// }

	// // Initialize the Gin router
	// router := gin.Default()

	// // config := cors.Default()
	// // config.AllowOrigins = []string{"*"} 
	// // config.AllowAllOrigins = true
	// // router.Use(cors.New(config))
	// router.Use(CORS())

	// // Initialize the database connection
	// psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable connect_timeout=0",
	// 	psql_host, psql_port, psql_user, psql_password, psql_dbname)
	// fmt.Printf("psqlInfo: %s\n", psqlInfo)

	// db := psql.InitDB(psqlInfo)

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


	// // Start the API server
	// port := "8080"
	// log.Printf("Server started on :%s\n", port)
	// log.Fatal(router.Run(":" + port))
}
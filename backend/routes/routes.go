package routes

import (
	"context"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"

	"main/models"
)

const collectionName = "clients";

func GetStatusHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "API up"})
}

func CreateClientHandler(c *gin.Context, database *mongo.Database) {
	var client models.Client
    if err := c.ShouldBindJSON(&client); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    collection := database.Collection(collectionName)

    // Insert the client data into the collection
    _, err := collection.InsertOne(context.Background(), client)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to insert client: " + err.Error()})
        return
    }

    c.JSON(http.StatusCreated, gin.H{"message": "Client created successfully"})
}

func GetClientsHandler(c *gin.Context, database *mongo.Database) {
    collection := database.Collection(collectionName)

    // Find all clients
    cursor, err := collection.Find(context.Background(), bson.M{})
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get clients: " + err.Error()})
        return
    }

    var clients []bson.M
    for cursor.Next(context.Background()) {
        
        //Create a value into which the single document can be decoded
        var client bson.M
        err := cursor.Decode(&client)
        if err != nil {
            log.Fatal(err)
        }
        client["id"] = client["_id"]
        delete(client, "_id")
        clients = append(clients, client)
    }

    if err := cursor.Err(); err != nil {
        log.Fatal(err)
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to decode clients: " + err.Error()})
        return
    }

    //Close the cursor once finished
    cursor.Close(context.Background())

    log.Println("client: ", clients)

    c.JSON(http.StatusOK, gin.H{"clients": clients})
}
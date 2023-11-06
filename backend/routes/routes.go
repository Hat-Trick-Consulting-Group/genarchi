package routes

import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"

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
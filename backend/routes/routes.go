package routes

import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"

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
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to decode client: " + err.Error()})
            return
        }
        client["id"] = client["_id"]
        delete(client, "_id")
        clients = append(clients, client)
    }

    if err := cursor.Err(); err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to decode clients: " + err.Error()})
        return
    }

    //Close the cursor once finished
    cursor.Close(context.Background())

    c.JSON(http.StatusOK, gin.H{"clients": clients})
}

func UpdateClientHandler(c *gin.Context, database *mongo.Database) {
    var client models.Client
    if err := c.ShouldBindJSON(&client); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    collection := database.Collection(collectionName)

    // Convert string client.ID to a MongoDB ObjectID
    objID, err := primitive.ObjectIDFromHex(client.ID)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid client ID format"})
        return
    }

    filter := bson.M{"_id": objID}

    update := bson.M{"$set": bson.M{"name": client.Name}}

    // Define options to return the updated document
    options := options.FindOneAndUpdate().SetReturnDocument(options.After)

    var updatedClient models.Client
    err = collection.FindOneAndUpdate(context.Background(), filter, update, options).Decode(&updatedClient)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update client: " + err.Error()})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Client updated successfully"})
}

func DeleteClientHandler(c *gin.Context, database *mongo.Database) {
    var client models.Client
    if err := c.ShouldBindJSON(&client); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    collection := database.Collection(collectionName)

    filter := bson.M{"name": client.Name}

    // Delete the client by name
    result, err := collection.DeleteMany(context.Background(), filter)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete client: " + err.Error()})
        return
    }

    if result.DeletedCount == 0 {
        c.JSON(http.StatusNotFound, gin.H{"error": "Client not found"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Client deleted successfully"})
}

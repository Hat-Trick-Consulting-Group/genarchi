package routes

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"

	"main/models"
)

func GetStatusHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "API up"})
}

func CreateClientHandler(c *gin.Context, db *sql.DB) {
	var newClient models.Client

	if err := c.BindJSON(&newClient); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Failed to parse request body"})
		return
	}

	// Use a prepared statement to insert data safely
	safeQuery, err := db.Prepare("INSERT INTO clients (name, email) VALUES ($1, $2);")
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


func GetClientsHandler(c *gin.Context, db *sql.DB) {
	var clients []models.Client

	rows, err := db.Query("SELECT * FROM clients;")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query the database"})
		return
	}

	defer rows.Close()

	for rows.Next() {
		var currentClient models.Client
		if err := rows.Scan(&currentClient.ID, &currentClient.Name, &currentClient.Email); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to scan the row"})
			return
		}
		clients = append(clients, currentClient)
	}

	c.JSON(http.StatusOK, gin.H{"clients": clients})
}

func UpdateClientHandler(c *gin.Context, db *sql.DB) {
	var clientToUpdate models.Client

	if err := c.BindJSON(&clientToUpdate); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Failed to parse request body"})
		return
	}
	if clientToUpdate.ID == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Missing ID"})
		return
	}

	// Use a prepared statement to update the client
	safeQuery, err := db.Prepare("UPDATE clients SET name=$2, email=$3 WHERE id=$1;")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to prepare SQL statement"})
		return
	}
	defer safeQuery.Close()

	_, err = safeQuery.Exec(clientToUpdate.ID, clientToUpdate.Name, clientToUpdate.Email)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update client in the database"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": fmt.Sprintf("Client updated successfully: ID=%d Name=%s, Email=%s", clientToUpdate.ID, clientToUpdate.Name, clientToUpdate.Email)})
}


func DeleteClientHandler(c *gin.Context, db *sql.DB) {
	var clientToDelete models.Client

	if err := c.BindJSON(&clientToDelete); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Failed to parse request body"})
		return
	}

	log.Printf("clientToDelete: %+v\n", clientToDelete)

	// Use a prepared statement to delete the client
	safeQuery, err := db.Prepare("DELETE FROM clients WHERE name=$1;")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to prepare SQL statement"})
		return
	}
	defer safeQuery.Close()

	_, err = safeQuery.Exec(clientToDelete.Name)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete client from the database"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": fmt.Sprintf("Client deleted successfully: Name=%s", clientToDelete.Name)})
}

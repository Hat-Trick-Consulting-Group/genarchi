package routes

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetStatusHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "API up"})
}
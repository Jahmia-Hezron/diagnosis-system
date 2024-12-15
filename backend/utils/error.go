package utils

import "github.com/gin-gonic/gin"

// RespondWithError sends an error response with a specific HTTP status code
func RespondWithError(c *gin.Context, status int, message string) {
	c.JSON(status, gin.H{"error": message})
}

// RespondBadRequest is a helper function for 400 Bad Request errors
func RespondBadRequest(c *gin.Context, message string) {
	RespondWithError(c, 400, message)
}

// RespondInternalServerError is a helper for 500 Internal Server errors
func RespondInternalServerError(c *gin.Context, message string) {
	RespondWithError(c, 500, message)
}

// RespondUnauthorized is a helper for 401 Unauthorized errors
func RespondUnauthorized(c *gin.Context, message string) {
	RespondWithError(c, 401, message)
}

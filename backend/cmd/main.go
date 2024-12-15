package main

import (
	"backend/config"
	"backend/models"
	"backend/repository"
	"backend/routes"
	"backend/services"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

// CORSMiddleware sets the CORS headers for handling cross-origin requests
func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")

		// Handle preflight requests
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(http.StatusOK)
			return
		}

		c.Next()
	}
}

func main() {
	// Load environment variables (optional, using godotenv)
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	// Initialize the database
	config.InitDB()

	// Auto migrate the models
	config.DB.AutoMigrate(&models.User{}, &models.DepressionDiagnosis{}, &models.AutismDiagnosis{})

	// Initialize repositories
	userRepo := repository.NewUserRepository(config.DB)
	depressionRepo := repository.NewDepressionDiagnosisRepository(config.DB)
	autismRepo := repository.NewAutismDiagnosisRepository(config.DB)

	// Initialize services
	userService := services.NewUserService(userRepo)
	depressionService := services.NewDepressionDiagnosisService(depressionRepo)
	autismService := services.NewAutismDiagnosisService(autismRepo)
	

	// Initialize Gin router with CORS middleware
	router := gin.Default()
	router.Use(CORSMiddleware()) // Apply the CORS middleware

	// Setup routes
	routes.SetupRoutes(router, userService, depressionService, autismService)

	// Start the server
	if err := router.Run(":8080"); err != nil {
		log.Fatal("failed to start server:", err)
	}
}

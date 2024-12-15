package routes

import (
	"backend/controllers"
	"backend/services"

	"github.com/gin-gonic/gin"
)

// SetupRoutes initializes the API routes
func SetupRoutes(
	router *gin.Engine, 
	userService *services.UserService,
	depressionService *services.DepressionDiagnosisService,
	autismService *services.AutismDiagnosisService, 
	) {

	userController := controllers.NewUserController(userService)
	depressionController := controllers.NewDepressionDiagnosisController(depressionService)
	autismController := controllers.NewAutismDiagnosisController(autismService)
	
	// User Routes
	userGroup := router.Group("/api/users")
	{
		userGroup.GET("/", userController.GetUsersByRole)
		userGroup.POST("/register", userController.Register)
		userGroup.POST("/login", userController.Login)
	}

	// Depression Diagnosis Routes
	depressionGroup := router.Group("/api/depression")
	{
		depressionGroup.POST("/", depressionController.CreateDiagnosis)
		depressionGroup.GET("/user/:user_id", depressionController.GetDiagnosesByUserID) // Implement this in the controller
	}

	// Autism Diagnosis Routes
	autismGroup := router.Group("/api/autism")
	{
		autismGroup.POST("/", autismController.CreateDiagnosis)
		autismGroup.GET("/user/:user_id", autismController.GetDiagnosesByUserID) // Implement this in the controller
	}

}

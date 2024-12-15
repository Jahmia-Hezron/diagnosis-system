package controllers

import (
	"backend/models"
	"backend/services"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// AutismDiagnosisController handles autism diagnosis requests
type AutismDiagnosisController struct {
	DiagnosisService *services.AutismDiagnosisService
}

// NewAutismDiagnosisController creates a new instance
func NewAutismDiagnosisController(as *services.AutismDiagnosisService) *AutismDiagnosisController {
	return &AutismDiagnosisController{DiagnosisService: as}
}

// CreateDiagnosis handles creating a new autism diagnosis
func (ac *AutismDiagnosisController) CreateDiagnosis(c *gin.Context) {
	var diagnosis models.AutismDiagnosis
	if err := c.ShouldBindJSON(&diagnosis); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	err := ac.DiagnosisService.CreateDiagnosis(&diagnosis)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Diagnosis created successfully"})
}

// GetDiagnosesByUserID retrieves all diagnoses for a specific user
func (ac *AutismDiagnosisController) GetDiagnosesByUserID(c *gin.Context) {
	userIDParam := c.Param("user_id")
	userID, err := strconv.ParseUint(userIDParam, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	diagnoses, err := ac.DiagnosisService.GetDiagnosesByUserID(uint(userID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, diagnoses)
}

package controllers

import (
	"backend/models"
	"backend/services"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// DepressionDiagnosisController handles depression diagnosis requests
type DepressionDiagnosisController struct {
	DiagnosisService *services.DepressionDiagnosisService
}

// NewDepressionDiagnosisController creates a new instance
func NewDepressionDiagnosisController(ds *services.DepressionDiagnosisService) *DepressionDiagnosisController {
	return &DepressionDiagnosisController{DiagnosisService: ds}
}

// CreateDiagnosis handles creating a new depression diagnosis
func (dc *DepressionDiagnosisController) CreateDiagnosis(c *gin.Context) {
	var diagnosis models.DepressionDiagnosis
	if err := c.ShouldBindJSON(&diagnosis); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	err := dc.DiagnosisService.CreateDiagnosis(&diagnosis)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Diagnosis created successfully"})
}

// GetDiagnosesByUserID retrieves all diagnoses for a specific user
func (dc *DepressionDiagnosisController) GetDiagnosesByUserID(c *gin.Context) {
	userIDParam := c.Param("user_id")
	userID, err := strconv.ParseUint(userIDParam, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	diagnoses, err := dc.DiagnosisService.GetDiagnosesByUserID(uint(userID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, diagnoses)
}

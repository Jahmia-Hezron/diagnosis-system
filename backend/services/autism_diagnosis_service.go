package services

import (
	"backend/models"
	"backend/repository"
	"errors"
)

// AutismDiagnosisService defines business logic for autism diagnosis
type AutismDiagnosisService struct {
	DiagnosisRepo repository.AutismDiagnosisRepository
}

// NewAutismDiagnosisService creates a new instance
func NewAutismDiagnosisService(diagnosisRepo repository.AutismDiagnosisRepository) *AutismDiagnosisService {
	return &AutismDiagnosisService{DiagnosisRepo: diagnosisRepo}
}

// CreateDiagnosis stores a new autism diagnosis
func (as *AutismDiagnosisService) CreateDiagnosis(diagnosis *models.AutismDiagnosis) error {
	if diagnosis.UserID == 0 || diagnosis.Score == 0 {
		return errors.New("invalid input")
	}

	// Generate result based on score (example logic)
	if diagnosis.Score < 5 {
		diagnosis.Result = "Low"
	} else if diagnosis.Score < 10 {
		diagnosis.Result = "Moderate"
	} else {
		diagnosis.Result = "High"
	}

	return as.DiagnosisRepo.CreateDiagnosis(diagnosis)
}

// GetDiagnosesByUserID retrieves all diagnoses for a specific user
func (as *AutismDiagnosisService) GetDiagnosesByUserID(userID uint) ([]models.AutismDiagnosis, error) {
	return as.DiagnosisRepo.GetDiagnosisByUserID(userID)
}

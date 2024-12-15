package services

import (
	"backend/models"
	"backend/repository"
	"errors"
)

// DepressionDiagnosisService defines business logic for depression diagnosis
type DepressionDiagnosisService struct {
	DiagnosisRepo repository.DepressionDiagnosisRepository
}

// NewDepressionDiagnosisService creates a new instance
func NewDepressionDiagnosisService(diagnosisRepo repository.DepressionDiagnosisRepository) *DepressionDiagnosisService {
	return &DepressionDiagnosisService{DiagnosisRepo: diagnosisRepo}
}

// CreateDiagnosis stores a new depression diagnosis
func (ds *DepressionDiagnosisService) CreateDiagnosis(diagnosis *models.DepressionDiagnosis) error {
	if diagnosis.UserID == 0 || diagnosis.Score == 0 {
		return errors.New("invalid input")
	}

	// Generate result based on score (example logic)
	if diagnosis.Score < 5 {
		diagnosis.Result = "Mild"
	} else if diagnosis.Score < 10 {
		diagnosis.Result = "Moderate"
	} else {
		diagnosis.Result = "Severe"
	}

	return ds.DiagnosisRepo.CreateDiagnosis(diagnosis)
}

// GetDiagnosesByUserID retrieves all diagnoses for a specific user
func (ds *DepressionDiagnosisService) GetDiagnosesByUserID(userID uint) ([]models.DepressionDiagnosis, error) {
	return ds.DiagnosisRepo.GetDiagnosisByUserID(userID)
}

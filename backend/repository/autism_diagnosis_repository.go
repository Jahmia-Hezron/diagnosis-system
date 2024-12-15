package repository

import (
	"backend/models"

	"gorm.io/gorm"
)

// AutismDiagnosisRepository interface for autism diagnosis operations
type AutismDiagnosisRepository interface {
	CreateDiagnosis(diagnosis *models.AutismDiagnosis) error
	GetDiagnosisByUserID(userID uint) ([]models.AutismDiagnosis, error)
}

// autismDiagnosisRepository struct implements the interface
type autismDiagnosisRepository struct {
	db *gorm.DB
}

// NewAutismDiagnosisRepository creates a new instance
func NewAutismDiagnosisRepository(db *gorm.DB) AutismDiagnosisRepository {
	return &autismDiagnosisRepository{db: db}
}

// CreateDiagnosis adds a new autism diagnosis record
func (r *autismDiagnosisRepository) CreateDiagnosis(diagnosis *models.AutismDiagnosis) error {
	return r.db.Create(diagnosis).Error
}

// GetDiagnosisByUserID retrieves diagnoses by user ID
func (r *autismDiagnosisRepository) GetDiagnosisByUserID(userID uint) ([]models.AutismDiagnosis, error) {
	var diagnoses []models.AutismDiagnosis
	if err := r.db.Where("user_id = ?", userID).Find(&diagnoses).Error; err != nil {
		return nil, err
	}
	return diagnoses, nil
}

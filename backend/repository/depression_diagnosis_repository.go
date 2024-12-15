package repository

import (
	"backend/models"

	"gorm.io/gorm"
)

// DepressionDiagnosisRepository interface for depression diagnosis operations
type DepressionDiagnosisRepository interface {
	CreateDiagnosis(diagnosis *models.DepressionDiagnosis) error
	GetDiagnosisByUserID(userID uint) ([]models.DepressionDiagnosis, error)
}

// depressionDiagnosisRepository struct implements the interface
type depressionDiagnosisRepository struct {
	db *gorm.DB
}

// NewDepressionDiagnosisRepository creates a new instance
func NewDepressionDiagnosisRepository(db *gorm.DB) DepressionDiagnosisRepository {
	return &depressionDiagnosisRepository{db: db}
}

// CreateDiagnosis adds a new depression diagnosis record
func (r *depressionDiagnosisRepository) CreateDiagnosis(diagnosis *models.DepressionDiagnosis) error {
	return r.db.Create(diagnosis).Error
}

// GetDiagnosisByUserID retrieves diagnoses by user ID
func (r *depressionDiagnosisRepository) GetDiagnosisByUserID(userID uint) ([]models.DepressionDiagnosis, error) {
	var diagnoses []models.DepressionDiagnosis
	if err := r.db.Where("user_id = ?", userID).Find(&diagnoses).Error; err != nil {
		return nil, err
	}
	return diagnoses, nil
}

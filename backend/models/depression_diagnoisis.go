package models

import "gorm.io/gorm"

// DepressionDiagnosis model to store diagnosis result
type DepressionDiagnosis struct {
	gorm.Model
	UserID uint   `json:"user_id"` // Foreign key
	Score  int    `json:"score"`   // PHQ-9 score
	Result string `json:"result"`  // 'Mild', 'Moderate', 'Severe'
}

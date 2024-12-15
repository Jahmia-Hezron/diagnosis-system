package models

import "gorm.io/gorm"

// AutismDiagnosis model to store autism diagnosis result
type AutismDiagnosis struct {
	gorm.Model
	UserID uint   `json:"user_id"` // Foreign key
	Score  int    `json:"score"`   // M-CHAT/AQ score
	Result string `json:"result"`  // 'Low', 'Moderate', 'High'
}

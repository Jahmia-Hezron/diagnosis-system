package repository

import (
	"backend/models"
	"errors"

	"gorm.io/gorm"
)

// UserRepository defines the interface for user data interaction
type UserRepository interface {
	CreateUser(user *models.User) error
	GetUserByEmail(email string) (*models.User, error)
	GetUsersByRole(role string) (*models.User, error)
}

// userRepository implements UserRepository interface
type userRepository struct {
	db *gorm.DB
}

// NewUserRepository creates a new instance of userRepository
func NewUserRepository(db *gorm.DB) UserRepository {
	return &userRepository{db: db}
}

// CreateUser inserts a new user into the database
func (r *userRepository) CreateUser(user *models.User) error {
	return r.db.Create(user).Error
}

// GetUserByEmail retrieves a user by their email
func (r *userRepository) GetUserByEmail(email string) (*models.User, error) {
	var user models.User
	result := r.db.Where("email = ?", email).First(&user)

	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, nil // User not found, return nil with no error
		}
		return nil, result.Error // Return the error if something else went wrong
	}
	return &user, nil // Return the found user
}

// GetUsersByRole retrieves users filtered by role
func (r *userRepository) GetUsersByRole(role string) (*models.User, error) {
	var user models.User
	result := r.db.Where("role = ?", role).Find(&user)
	if result.Error != nil {
		return nil, result.Error
	}
	return &user, nil
}



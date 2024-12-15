package services

import (
	"backend/models"
	"backend/repository"
	"errors"
	"log"
	"strings"

	"golang.org/x/crypto/bcrypt"
)

// UserService defines user-related business logic
type UserService struct {
	UserRepo repository.UserRepository
}

// NewUserService creates a new instance of UserService
func NewUserService(userRepo repository.UserRepository) *UserService {
	return &UserService{UserRepo: userRepo}
}

func (us *UserService) RegisterUser(user *models.User) error {
	// Check if email already exists
	existingUser, err := us.UserRepo.GetUserByEmail(user.Email)
	if err != nil {
		log.Println("Error checking email:", err)
		return errors.New("internal server error") // Handle unexpected errors
	}
	if existingUser != nil {
		return errors.New("email already exists")
	}

	// Hash the password before saving
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return errors.New("failed to hash password")
	}
	user.Password = string(hashedPassword)

	// Log the hashed password for debugging
	log.Printf("User registered: %s, Hashed Password: %s", user.Email, user.Password)

	return us.UserRepo.CreateUser(user)
}

func (us *UserService) LoginUser(email string, password string) (*models.User, error) {
	trimmedPassword := strings.TrimSpace(password)
	log.Printf("Login attempt for email: %s with password length: %d", email, len(trimmedPassword))
	user, err := us.UserRepo.GetUserByEmail(email)
	if err != nil || user == nil {
		log.Println("Error retrieving user:", err)
		return nil, errors.New("invalid email or password")
	}

	log.Printf("Stored Hashed Password: %s", user.Password)
	

	// Compare the plain text password with the stored hashed password
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(trimmedPassword)); err != nil {
		log.Println("Password mismatch:", err)
		return nil, errors.New("invalid email or password")
	}

	log.Printf("User logged in: %s", email)
	return user, nil

	
}

// GetUsersByRole fetches users by their role
func (us *UserService) GetUsersByRole(role string) (*models.User, error) {
	return us.UserRepo.GetUsersByRole(role);
}





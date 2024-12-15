package utils

import (
	"log"
)

// Initialize the logger with custom settings (optional)
func init() {
	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)
}

// Info logs general informational messages
func Info(message string) {
	log.Printf("[INFO] %s", message)
}

// Error logs error messages
func Error(err error) {
	if err != nil {
		log.Printf("[ERROR] %s", err.Error())
	}
}

// Fatal logs critical errors and exits the application
func Fatal(err error) {
	if err != nil {
		log.Fatalf("[FATAL] %s", err.Error())
	}
}

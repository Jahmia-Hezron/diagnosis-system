# ****Depression and Autism Diagnosis System****
## **Overview**
The Depression and Autism Diagnosis System is an innovative platform designed to help individuals in Uganda screen for depression and autism. By leveraging well-established diagnostic tools such as PHQ-9 for depression and AQ/M-CHAT for autism, the system allows users to fill out diagnostic forms, receive scores, and obtain a preliminary assessment. The system empowers users with insights into their mental health and encourages them to seek professional help if needed.

## **Features**
- User Authentication: Secure sign-up and login functionalities to protect user data.
- Depression Screening: PHQ-9 questionnaire to evaluate the severity of depression.
- Autism Screening: AQ or M-CHAT forms tailored to users' demographics.
- Dynamic Forms: Interactive forms that adapt based on user inputs for a seamless experience.
- Real-time Feedback: Instant calculation of scores with recommendations for seeking professional help if necessary.
- Data Security: Strong encryption and security measures to ensure user privacy.
- Admin Dashboard: Admin panel to manage users and view analytics.

## **System Architecture**
The system is structured using the following components:
- **Frontend (Flutter):** User interface for web and mobile, where users interact with the system to complete diagnostic forms.
- **Backend (Go):** Handles authentication, form processing, and score calculation.
- **Database (MySQL):** Stores user data, diagnostic responses, and historical records.

## **Technologies Used**
- Frontend: Flutter (for building cross-platform mobile and web apps)
- Backend: Go (with GORM for MySQL integration)
- Database: MySQL (for secure storage of user data and results)
- Security: HTTPS, encryption for data storage, and secure authentication protocols.

## **Installation Prerequisites**
- Flutter (for frontend development)
- Go (for backend development)
- MySQL (for database management)

# **Steps to Run the Application**
## **Clone the repository:**
- git clone https://github.com/your-repository-url.git

## **Set up the MySQL database:**
- Install MySQL and create a new database (e.g., mental_health_system).
- Run the SQL script to set up the required tables.

## **Configure environment variables:**
- Set the database connection string in the backend configuration file.
- Set up secret keys for JWT authentication and other environment-specific configurations.

## **Install dependencies for the backend:**
- cd backend
- go mod tidy

## **Install dependencies for the frontend:**
- cd frontend
- flutter pub get

## **Start the backend server:**
- go run main.go

## **Start the Flutter app:**
- flutter run
- The application should now be running locally.


# **Usage**
- ## **User Registration/Login:**
  Users can sign up or log in to the system securely using their email and password.

- ## **Depression Screening:**
  Users complete the PHQ-9 form, which helps assess the severity of their depression symptoms.

- ## **Autism Screening:**
  Users can complete the AQ or M-CHAT diagnostic form, depending on their demographics (adult or child).

- ## **Results and Feedback:**
  After completing the form, the system calculates the scores and provides immediate feedback along with recommendations for seeking professional help if necessary.

- ## **Admin Dashboard:**
  Admins can view user data, analyze results, and manage user accounts.

# **System Workflow**
User Registration/Authentication
Users register or log in securely.

- ## **Diagnostic Form Submission**
  Users select and complete the depression (PHQ-9) or autism (AQ/M-CHAT) form.

- ## **Results Calculation**
  The system processes user responses, calculates the score, and displays the results.

- ## **Feedback and Recommendations**
  The system provides feedback and suggests professional help if required.

- ## **Admin Monitoring**
  Admins manage user accounts, view analytics, and monitor system usage.

- ## **Data Privacy & Security**
  - User Authentication: All passwords are securely hashed and stored.
  - Data Encryption: User data and responses are encrypted both in transit and at rest.
  - Access Control: Only authorized users (admins) can access sensitive data.
  - The system adheres to best practices for data privacy and complies with relevant data protection regulations.


- # **Future Enhancements**
  - Multilingual Support: To support a broader range of users across Uganda.
  - Mobile App Optimization: To improve user experience on mobile devices.
  - Enhanced Analytics: For more detailed insights into user engagement and mental health trends.

# **Contributing**
We welcome contributions to improve this system. If you’d like to contribute, please follow these steps:

## **Fork the repository.**
- Create a new branch for your feature or bug fix.
- Make your changes and commit them.
- Open a pull request for review.
  
# **License**
This project is licensed under the MIT License - see the LICENSE file for details.

# **Contact**
For more information or inquiries, please contact JAHMIA HEZRON PRESCI at hezron.p.jahmia or +256752580722



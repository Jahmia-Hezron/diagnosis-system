class SessionServices {
  static int? userId;
  static String? userName;

  SessionServices._internal();

  // Set the user ID after successful login
  static void setUserId(int id) {
    userId = id;
  }

  static void setUserName(String name) {
    userName = name;
  }

  // Get the current logged-in user ID
  static int? getUserId() {
    return userId;
  }

  static String? getUserName() {
    return userName;
  }

  // Clear session (e.g., on logout)
  static void clearSession() {
    userId = null;
  }
}

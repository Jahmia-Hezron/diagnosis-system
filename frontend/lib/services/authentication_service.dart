import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthenticationService {
  static const String usersUrl = 'http://localhost:8080/api/users';

  static Future<http.Response> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('$usersUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    return response;
  }

  static Future<http.Response> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$usersUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response;
  }
}

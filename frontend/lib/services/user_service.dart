import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "http://localhost:8080/api/users";

  static Future<List<dynamic>> fetchPatients() async {
    final response = await http.get(Uri.parse('$baseUrl?role=patient'));

    if (response.statusCode == 200) {
      log('Response Body: ${response.body}');
      final dynamic patients = json.decode(response.body);

      // If the response is a single user, return it inside a list
      if (patients is Map<String, dynamic>) {
        return [patients];
      } else if (patients is List) {
        return patients;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load patients');
    }
  }

  static Future<List<dynamic>> fetchDoctors() async {
    final response = await http.get(Uri.parse('$baseUrl?role=doctor'));

    if (response.statusCode == 200) {
      log('Response Body: ${response.body}');
      final dynamic doctors = json.decode(response.body);

      // If the response is a single user, return it inside a list
      if (doctors is Map<String, dynamic>) {
        return [doctors];
      } else if (doctors is List) {
        return doctors;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load doctors');
    }
  }
}

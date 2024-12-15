import 'dart:convert';
import 'package:http/http.dart' as http;

class DiagnosisService {
  static const String baseUrl = "http://localhost:8080/api";
  // Fetch all Autism Diagnoses
  static Future<List<dynamic>> fetchAllAutismDiagnoses() async {
    final response = await http.get(Uri.parse('$baseUrl/autism'));

    if (response.statusCode == 200) {
      List<dynamic> autismDiagnoses = json.decode(response.body);
      return autismDiagnoses;
    } else {
      throw Exception('Failed to load all autism diagnoses');
    }
  }

  // Fetch all Depression Diagnoses
  static Future<List<dynamic>> fetchAllDepressionDiagnoses() async {
    final response = await http.get(Uri.parse('$baseUrl/depression'));

    if (response.statusCode == 200) {
      List<dynamic> depressionDiagnoses = json.decode(response.body);
      return depressionDiagnoses;
    } else {
      throw Exception('Failed to load all depression diagnoses');
    }
  }

  // Fetch Autism Diagnosis by User ID
  static Future<List<dynamic>> fetchAutismDiagnosesByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/autism/user/$userId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> autismDiagnoses = json.decode(response.body);
      return autismDiagnoses;
    } else {
      throw Exception('Failed to load autism diagnoses');
    }
  }

  // Fetch Depression Diagnosis by User ID
  static Future<List<dynamic>> fetchDepressionDiagnosesByUserId(
      int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/depression/user/$userId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> depressionDiagnoses = json.decode(response.body);
      return depressionDiagnoses;
    } else {
      throw Exception('Failed to load depression diagnoses');
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../models/autism_diagnosis.dart';
import '../models/depression_diagnosis.dart';

class DiagnosticService {
  static const String depressionUrl = 'http://localhost:8080/api/depression/';
  static const String autismUrl = 'http://localhost:8080/api/autism/';

  static Future<bool> submitPHQ9Diagnosis(
      PHQ9Diagnosis depressionDiagnosis) async {
    try {
      final response = await http.post(
        Uri.parse(depressionUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(depressionDiagnosis.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Error: ${response.body}');
        return false;
      }
    } on Exception catch (error) {
      log('Exception occurred: $error');
      return false;
    }
  }

  static Future<bool> submitAQDiagnosis(AQDiagnosis autismDiagnosis) async {
    try {
      final response = await http.post(
        Uri.parse(autismUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(autismDiagnosis.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Error: ${response.body}');
        return false;
      }
    } on Exception catch (error) {
      log('Exception occurred: $error');
      return false;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lab_test.dart';

class LabTestService {
  static const String baseUrl =
      "http://10.219.39.162:3000/api/v1/patientRecords";

  static Future<List<LabTest>> getLabTests(String patientId) async {
    final url = Uri.parse('$baseUrl/laborder/$patientId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LabTest.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lab tests: ${response.statusCode}');
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/care_plan.dart';

class CarePlanService {
  static const String baseUrl =
      "http://10.219.39.162:3000/api/v1/patientRecords";

  static Future<List<CarePlan>> getCarePlans(String patientId) async {
    final url = Uri.parse('$baseUrl/careplans/$patientId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CarePlan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load care plans: ${response.statusCode}');
    }
  }
}
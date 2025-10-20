// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/prescription.dart';
// import 'auth_service.dart';
//
// class PrescriptionService {
//   static const String baseUrl =
//       'http://10.219.39.162:3000/api/v1/patientRecords/prescription';
//
//   static Future<List<Prescription>> getPrescriptions([
//     String? patientId,
//   ]) async {
//     final id = patientId ?? await AuthService.getUserId();
//     if (id == null) throw Exception('User ID not found');
//
//     final token = await AuthService.getToken();
//     final headers = {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//
//     final url = '$baseUrl/$id';
//     print('📡 GET $url');
//
//     final response = await http.get(Uri.parse(url), headers: headers);
//
//     print('Status code: ${response.statusCode}');
//     print('Body: ${response.body}');
//
//     if (response.statusCode == 200) {
//       final List data = json.decode(response.body);
//       return data.map((json) => Prescription.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to fetch prescriptions');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prescription.dart';
import 'auth_service.dart';

class PrescriptionService {
  static const String baseUrl =
      'http://10.219.39.162:3000/api/v1/patientRecords/prescription';

  static Future<List<Prescription>> getPrescriptions() async {
    final patientId = await AuthService.getUserId();
    if (patientId == null) throw Exception('User ID not found');

    final url = '$baseUrl/$patientId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Prescription.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch prescriptions');
    }
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../../models/metric.dart';
import '../../services/auth_service.dart';

class RecordMetricsScreen extends StatefulWidget {
  const RecordMetricsScreen({super.key});

  @override
  State<RecordMetricsScreen> createState() => _RecordMetricsScreenState();
}

class _RecordMetricsScreenState extends State<RecordMetricsScreen> {
  final _metricsFormKey = GlobalKey<FormState>();
  final _familyFormKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();
  final _weightController = TextEditingController();
  final _sugarController = TextEditingController();
  final _waterController = TextEditingController();

  final _familyNameController = TextEditingController();
  final _familyAgeController = TextEditingController();
  final _familyRelationController = TextEditingController();

  List<String> _selectedFileNames = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toString().split(' ')[0];
  }

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    _sugarController.dispose();
    _waterController.dispose();
    _familyNameController.dispose();
    _familyAgeController.dispose();
    _familyRelationController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFileNames.add(result.files.first.name);
      });
    }
  }

  Future<void> saveMetrics() async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('http://10.21.130.26:3003/api/v1/metrics'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "date": _dateController.text,
        "weight": double.parse(_weightController.text),
        "sugarLevel": double.tryParse(_sugarController.text),
        "waterIntake": double.tryParse(_waterController.text),
      }),
    );

    if (response.statusCode == 201) {
      print("Metrics saved successfully");
    } else {
      print("Error saving metrics: ${response.statusCode} - ${response.body}");
      print(response);
    }
  }

  Future<List<Metric>> fetchMetrics() async {
    final response = await http.get(
      Uri.parse('http://10.21.130.26:3000/patient-records/metrics'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Metric.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load metrics');
    }
  }

  Future<void> uploadReport(String filePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.21.130.26:3000/patient-records/reports'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var res = await request.send();
    if (res.statusCode == 201) {
      print("Report uploaded");
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Metrics Section
            ExpansionTile(
              title: const Text(
                'Daily Metrics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              initiallyExpanded: true,
              children: [
                Form(
                  key: _metricsFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _dateController.text = pickedDate
                                      .toString()
                                      .split(' ')[0];
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          prefixIcon: Icon(Icons.monitor_weight),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter weight'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _sugarController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Sugar Level (mg/dL)',
                          prefixIcon: Icon(Icons.bloodtype),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _waterController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Water Intake (liters)',
                          prefixIcon: Icon(Icons.water_drop),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (_metricsFormKey.currentState!.validate()) {
                              try {
                                await saveMetrics();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Metrics saved successfully!',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print('Error saving metrics: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error saving metrics: $e'),
                                  ),
                                );
                              }
                            }
                          },

                          icon: const Icon(Icons.save),
                          label: const Text('Save Metrics'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Patient Report Section
            ExpansionTile(
              title: const Text(
                'Add Patient Reports',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...(_selectedFileNames.isEmpty
                          ? [
                              GestureDetector(
                                onTap: _pickFile,
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.grey.shade50,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 28,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.cloud_upload,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Tap to add a report',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          : [
                              for (
                                int i = 0;
                                i < _selectedFileNames.length;
                                i++
                              ) ...[
                                Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  elevation: 1,
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.insert_drive_file,
                                    ),
                                    title: Text(_selectedFileNames[i]),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () => _selectedFileNames.removeAt(i),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: _pickFile,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Another Report'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Saved ${_selectedFileNames.length} report(s)!',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.save),
                                label: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('Save All Reports'),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ]),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Family Members Section
            // ExpansionTile(
            //   title: const Text(
            //     'Add Family Member',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            //   ),
            //   children: [
            //     Form(
            //       key: _familyFormKey,
            //       child: Column(
            //         children: [
            //           TextFormField(
            //             controller: _familyNameController,
            //             decoration: const InputDecoration(
            //               labelText: 'Full Name',
            //               prefixIcon: Icon(Icons.person),
            //             ),
            //             validator: (value) => value == null || value.isEmpty
            //                 ? 'Enter name'
            //                 : null,
            //           ),
            //           const SizedBox(height: 12),
            //           TextFormField(
            //             controller: _familyAgeController,
            //             keyboardType: TextInputType.number,
            //             decoration: const InputDecoration(
            //               labelText: 'Age',
            //               prefixIcon: Icon(Icons.cake),
            //             ),
            //             validator: (value) =>
            //                 value == null || value.isEmpty ? 'Enter age' : null,
            //           ),
            //           const SizedBox(height: 12),
            //           TextFormField(
            //             controller: _familyRelationController,
            //             decoration: const InputDecoration(
            //               labelText: 'Relation',
            //               prefixIcon: Icon(Icons.family_restroom),
            //             ),
            //             validator: (value) => value == null || value.isEmpty
            //                 ? 'Enter relation'
            //                 : null,
            //           ),
            //           const SizedBox(height: 16),
            //           SizedBox(
            //             width: double.infinity,
            //             child: ElevatedButton.icon(
            //               onPressed: () {
            //                 if (_familyFormKey.currentState!.validate()) {
            //                   ScaffoldMessenger.of(context).showSnackBar(
            //                     SnackBar(
            //                       content: Text(
            //                         'Family member "${_familyNameController.text}" saved!',
            //                       ),
            //                     ),
            //                   );
            //                   _familyNameController.clear();
            //                   _familyAgeController.clear();
            //                   _familyRelationController.clear();
            //                 }
            //               },
            //               icon: const Icon(Icons.save),
            //               label: const Text('Save Family Member'),
            //               style: ElevatedButton.styleFrom(
            //                 backgroundColor: primaryColor,
            //                 padding: const EdgeInsets.symmetric(vertical: 14),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
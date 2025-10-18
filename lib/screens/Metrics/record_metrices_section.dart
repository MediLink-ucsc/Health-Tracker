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
  final _dateController = TextEditingController();
  final _weightController = TextEditingController();
  final _sugarController = TextEditingController();
  final _waterController = TextEditingController();
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
      Uri.parse('http://10.219.39.162:3003/api/v1/metrics'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Metrics saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving metrics: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    InputDecoration modernInput(String label, IconData icon, Color color) {
      return InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Metrics Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _metricsFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Daily Metrics',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: modernInput(
                          'Date',
                          Icons.calendar_today,
                          Colors.teal,
                        ),
                        onTap: () async {
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
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: modernInput(
                          'Weight (kg)',
                          Icons.monitor_weight,
                          Colors.orange,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter weight'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _sugarController,
                        keyboardType: TextInputType.number,
                        decoration: modernInput(
                          'Sugar Level (mg/dL)',
                          Icons.bloodtype,
                          Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _waterController,
                        keyboardType: TextInputType.number,
                        decoration: modernInput(
                          'Water Intake (L)',
                          Icons.water_drop,
                          Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_metricsFormKey.currentState!.validate()) {
                            saveMetrics();
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Save Metrics'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reports Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Patient Reports',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...(_selectedFileNames.isEmpty
                        ? [
                            GestureDetector(
                              onTap: _pickFile,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.cloud_upload,
                                    size: 40,
                                    color: Colors.grey,
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
                              ListTile(
                                leading: const Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.teal,
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
                            ],
                          ]),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
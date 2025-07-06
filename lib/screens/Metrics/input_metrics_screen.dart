import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../Components/custom_bottom_nav.dart';

class InputMetricsScreen extends StatefulWidget {
  const InputMetricsScreen({super.key});

  @override
  State<InputMetricsScreen> createState() => _InputMetricsScreenState();
}

class _InputMetricsScreenState extends State<InputMetricsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();

  bool _showReportSection = false;
  String? _selectedFileName;

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
        _selectedFileName = result.files.first.name;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Daily Metrics'),
        backgroundColor: primaryColor,
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Date field
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
                          _dateController.text = pickedDate.toString().split(
                            ' ',
                          )[0];
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Sugar Level
              TextFormField(
                controller: _sugarController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Sugar Level (mg/dL)',
                  prefixIcon: Icon(Icons.bloodtype),
                ),
              ),
              const SizedBox(height: 16),

              // Water Intake
              TextFormField(
                controller: _waterController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Water Intake (liters)',
                  prefixIcon: Icon(Icons.water_drop),
                ),
              ),
              const SizedBox(height: 32),

              // Save Metrics button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Metrics saved successfully!'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Metrics'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Add Report button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showReportSection = !_showReportSection;
                    });
                  },
                  icon: Icon(_showReportSection ? Icons.close : Icons.note_add),
                  label: Text(
                    _showReportSection
                        ? 'Hide Report Section'
                        : 'Add Patient Report',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Report section
              // Visibility(
              //   visible: _showReportSection,
              //   child: Container(
              //     padding: const EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       color: Colors.grey.shade50,
              //       border: Border.all(color: Colors.grey.shade300),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Patient Report',
              //           style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         const SizedBox(height: 8),
              //         const Divider(),
              //         const SizedBox(height: 12),
              //         GestureDetector(
              //           onTap: _pickFile,
              //           child: Container(
              //             width: double.infinity,
              //             padding: const EdgeInsets.symmetric(vertical: 28),
              //             decoration: BoxDecoration(
              //               border: Border.all(
              //                 color: Colors.grey.shade400,
              //                 style: BorderStyle.solid,
              //               ),
              //               borderRadius: BorderRadius.circular(6),
              //               color: Colors.grey.shade100,
              //             ),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 const Icon(
              //                   Icons.cloud_upload,
              //                   size: 40,
              //                   color: Colors.grey,
              //                 ),
              //                 const SizedBox(height: 8),
              //                 Text(
              //                   _selectedFileName ?? 'Tap to choose a file',
              //                   style: TextStyle(
              //                     color: _selectedFileName != null
              //                         ? Colors.black87
              //                         : Colors.grey,
              //                     fontWeight: FontWeight.w500,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //         if (_selectedFileName != null)
              //           Align(
              //             alignment: Alignment.centerRight,
              //             child: TextButton.icon(
              //               onPressed: () {
              //                 setState(() {
              //                   _selectedFileName = null;
              //                 });
              //               },
              //               icon: const Icon(Icons.clear, color: Colors.red),
              //               label: const Text(
              //                 'Remove',
              //                 style: TextStyle(color: Colors.red),
              //               ),
              //             ),
              //           ),
              //       ],
              //     ),
              //   ),
              // ),
              Visibility(
                visible: _showReportSection,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Patient Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _pickFile,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 28),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey.shade100,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.cloud_upload,
                                size: 40,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedFileName ?? 'Tap to choose a file',
                                style: TextStyle(
                                  color: _selectedFileName != null
                                      ? Colors.black87
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_selectedFileName != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _selectedFileName = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Remove',
                                  style: TextStyle(color: Colors.red),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  minimumSize: const Size(
                                    0,
                                    36,
                                  ), // remove min width constraint
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Add your save report logic here
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Report "$_selectedFileName" saved successfully!',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.save),
                                label: const Text(
                                  'Save Report',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D9488),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  minimumSize: const Size(
                                    0,
                                    36,
                                  ), // remove min width constraint
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
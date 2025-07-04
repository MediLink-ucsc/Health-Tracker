import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Daily Metrics'),
        backgroundColor: primaryColor,
      ),
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

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Save logic
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
            ],
          ),
        ),
      ),
    );
  }
}
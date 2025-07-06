import 'package:fl_chart/fl_chart.dart';
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

  // Simulated full year data for charts (random-ish)
  final List<double> allWeightData = List.generate(
    365,
    (i) => 65 + (i % 7) * 0.5,
  );
  final List<double> allSugarData = List.generate(
    365,
    (i) => 90 + (i % 10) * 1.2,
  );
  final List<double> allWaterData = List.generate(
    365,
    (i) => 1.8 + (i % 5) * 0.1,
  );

  // Height for BMI calculation
  final double heightMeters = 1.70;

  // Selected chart range: Week, Month, Year
  String selectedRange = 'Week';

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
    }
  }

  // BMI range annotations for weight chart
  List<HorizontalRangeAnnotation> _getBmiRanges() {
    final double h2 = heightMeters * heightMeters;

    final double underweightMax = (18.5 * h2).clamp(40, 100);
    final double normalMin = (18.5 * h2).clamp(40, 100);
    final double normalMax = (24.9 * h2).clamp(40, 100);
    final double overweightMin = (25 * h2).clamp(40, 100);
    final double overweightMax = (29.9 * h2).clamp(40, 100);
    final double obeseMin = (30 * h2).clamp(40, 100);
    final double obeseMax = 100;

    return [
      HorizontalRangeAnnotation(
        y1: 40,
        y2: underweightMax,
        color: Colors.blue.withOpacity(0.15),
      ),
      HorizontalRangeAnnotation(
        y1: normalMin,
        y2: normalMax,
        color: Colors.green.withOpacity(0.15),
      ),
      HorizontalRangeAnnotation(
        y1: overweightMin,
        y2: overweightMax,
        color: Colors.orange.withOpacity(0.15),
      ),
      HorizontalRangeAnnotation(
        y1: obeseMin,
        y2: obeseMax,
        color: Colors.red.withOpacity(0.15),
      ),
    ];
  }

  // Filter and aggregate data based on selected range
  List<double> _getFilteredData(List<double> data) {
    if (selectedRange == 'Week') {
      // Last 7 days reversed for newest last
      return data.take(7).toList().reversed.toList();
    } else if (selectedRange == 'Month') {
      // Last 30 days reversed
      return data.take(30).toList().reversed.toList();
    } else {
      // Year: aggregate by month (approx 30 days each)
      List<double> monthlyData = [];
      for (int m = 0; m < 12; m++) {
        int start = m * 30;
        int end = start + 30;
        if (end > data.length) end = data.length;
        var slice = data.sublist(start, end);
        double avg = slice.isNotEmpty
            ? slice.reduce((a, b) => a + b) / slice.length
            : 0;
        monthlyData.add(avg);
      }
      return monthlyData.reversed.toList();
    }
  }

  // Builds a line chart with optional custom bottom labels
  Widget _buildLineChart({
    required List<double> data,
    required double minY,
    required double maxY,
    required Color color,
    required String title,
    Widget Function(double value, TitleMeta meta)? bottomLabelBuilder,
    List<HorizontalRangeAnnotation>? rangeAnnotations,
  }) {
    final filteredData = _getFilteredData(data);
    final labelInterval = (filteredData.length / 6).floorToDouble().clamp(
      1,
      10,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(show: false),
                rangeAnnotations: rangeAnnotations != null
                    ? RangeAnnotations(
                        horizontalRangeAnnotations: rangeAnnotations,
                      )
                    : null,
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(),
                    bottom: BorderSide(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      filteredData.length,
                      (index) => FlSpot(index + 1, filteredData[index]),
                    ),
                    isCurved: true,
                    barWidth: 3,
                    color: color,
                    dotData: FlDotData(show: true),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 10,
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: labelInterval.toDouble(),
                      reservedSize: 24,
                      getTitlesWidget:
                          bottomLabelBuilder ??
                          (value, meta) {
                            final day = value.toInt();
                            if (day < 1 || day > filteredData.length) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              'Day $day',
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    // Month labels for Year range
    Widget monthLabelBuilder(double value, TitleMeta meta) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      int monthIndex = value.toInt() - 1;
      if (monthIndex < 0 || monthIndex >= months.length) {
        return const SizedBox.shrink();
      }
      return Text(months[monthIndex], style: const TextStyle(fontSize: 10));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Daily Metrics'),
        backgroundColor: primaryColor,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Date
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

                  // Sugar
                  TextFormField(
                    controller: _sugarController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Sugar Level (mg/dL)',
                      prefixIcon: Icon(Icons.bloodtype),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Water
                  TextFormField(
                    controller: _waterController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Water Intake (liters)',
                      prefixIcon: Icon(Icons.water_drop),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save Metrics button full width
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Add Patient Report button full width toggle
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showReportSection = !_showReportSection;
                        });
                      },
                      icon: Icon(
                        _showReportSection ? Icons.close : Icons.note_add,
                      ),
                      label: Text(
                        _showReportSection
                            ? 'Hide Report Section'
                            : 'Add Patient Report',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Report Section (file picker)
            if (_showReportSection)
              Container(
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
                          border: Border.all(color: Colors.grey.shade400),
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
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedFileName = null;
                              });
                            },
                            icon: const Icon(Icons.clear, color: Colors.red),
                            label: const Text(
                              'Remove',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Report "$_selectedFileName" saved successfully!',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.save),
                            label: const Text('Save Report'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Range toggle buttons for charts with nicer spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Week'),
                  selected: selectedRange == 'Week',
                  onSelected: (_) => setState(() => selectedRange = 'Week'),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Month'),
                  selected: selectedRange == 'Month',
                  onSelected: (_) => setState(() => selectedRange = 'Month'),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Year'),
                  selected: selectedRange == 'Year',
                  onSelected: (_) => setState(() => selectedRange = 'Year'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Weight Chart with BMI ranges & month labels for Year
            _buildLineChart(
              data: allWeightData,
              minY: 40,
              maxY: 100,
              color: Colors.teal,
              title: 'Weight Trend (kg)',
              bottomLabelBuilder: (value, meta) {
                if (selectedRange == 'Year') {
                  const months = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec',
                  ];
                  int monthIndex = value.toInt() - 1;
                  if (monthIndex < 0 || monthIndex >= months.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    months[monthIndex],
                    style: const TextStyle(fontSize: 10),
                  );
                } else {
                  final day = value.toInt();
                  final filteredLength = _getFilteredData(allWeightData).length;
                  if (day < 1 || day > filteredLength) {
                    return const SizedBox.shrink();
                  }
                  return Text('Day $day', style: const TextStyle(fontSize: 10));
                }
              },
              rangeAnnotations: _getBmiRanges(),
            ),

            // Sugar Chart
            _buildLineChart(
              data: allSugarData,
              minY: 80,
              maxY: 110,
              color: Colors.orange,
              title: 'Sugar Level Trend (mg/dL)',
            ),

            // Water Intake Chart
            _buildLineChart(
              data: allWaterData,
              minY: 1.5,
              maxY: 2.5,
              color: Colors.blue,
              title: 'Water Intake Trend (liters)',
            ),
          ],
        ),
      ),
    );
  }
}
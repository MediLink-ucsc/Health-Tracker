import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/models/metric.dart';

class MetricsSummaryScreen extends StatefulWidget {
  const MetricsSummaryScreen({super.key});

  @override
  State<MetricsSummaryScreen> createState() => _MetricsSummaryScreenState();
}

class _MetricsSummaryScreenState extends State<MetricsSummaryScreen> {
  List<Metric> allMetrics = [];
  String selectedRange = 'Week';
  final double heightMeters = 1.70;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    try {
      final metrics = await fetchMetrics();

      // Debug print to check fetched data
      print('Fetched ${metrics.length} metrics');
      for (var m in metrics) {
        print(
          'Metric: date=${m.date}, weight=${m.weight}, sugarLevel=${m.sugarLevel}, waterIntake=${m.waterIntake}',
        );
      }

      setState(() {
        allMetrics = metrics;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<List<Metric>> fetchMetrics() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.100:3000/api/v1/metrics'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Metric.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load metrics');
    }
  }

  List<double> _getFilteredData(List<double> data) {
    if (data.isEmpty) return [];

    if (selectedRange == 'Week') {
      final takeCount = data.length >= 7 ? 7 : data.length;
      return data.take(takeCount).toList().reversed.toList();
    } else if (selectedRange == 'Month') {
      final takeCount = data.length >= 30 ? 30 : data.length;
      return data.take(takeCount).toList().reversed.toList();
    } else {
      final monthCount = 12;
      final daysPerMonth = 30;
      List<double> result = [];
      for (int m = 0; m < monthCount; m++) {
        final start = m * daysPerMonth;
        if (start >= data.length) break;
        final end = ((start + daysPerMonth).clamp(0, data.length)).toInt();
        final slice = data.sublist(start, end);
        if (slice.isNotEmpty) {
          final avg = slice.reduce((a, b) => a + b) / slice.length;
          result.add(avg);
        }
      }
      return result.reversed.toList();
    }
  }

  List<double> _getFilteredWeights() =>
      _getFilteredData(allMetrics.map((m) => m.weight).toList());

  List<double> _getFilteredSugarLevels() =>
      _getFilteredData(allMetrics.map((m) => m.sugarLevel ?? 0).toList());

  List<double> _getFilteredWaterIntakes() =>
      _getFilteredData(allMetrics.map((m) => m.waterIntake ?? 0).toList());

  List<HorizontalRangeAnnotation> _getBmiRanges() {
    final h2 = heightMeters * heightMeters;
    return [
      HorizontalRangeAnnotation(
        y1: 40,
        y2: (18.5 * h2).clamp(40, 100),
        color: Colors.blue.withOpacity(0.15),
      ),
      HorizontalRangeAnnotation(
        y1: (18.5 * h2).clamp(40, 100),
        y2: (24.9 * h2).clamp(40, 100),
        color: Colors.green.withOpacity(0.15),
      ),
      HorizontalRangeAnnotation(
        y1: (25 * h2).clamp(40, 100),
        y2: (29.9 * h2).clamp(40, 100),
        color: Colors.orange.withOpacity(0.15),
      ),
      HorizontalRangeAnnotation(
        y1: (30 * h2).clamp(40, 100),
        y2: 100,
        color: Colors.red.withOpacity(0.15),
      ),
    ];
  }

  Widget _buildChart(
    String title,
    List<double> data,
    double minY,
    double maxY,
    Color color, {
    List<HorizontalRangeAnnotation>? ranges,
  }) {
    final filtered = data;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(),
                    bottom: BorderSide(),
                  ),
                ),
                rangeAnnotations: ranges != null
                    ? RangeAnnotations(horizontalRangeAnnotations: ranges)
                    : null,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      filtered.length,
                      (i) => FlSpot(i + 1, filtered[i].toDouble()),
                    ),
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 10,
                      getTitlesWidget: (value, _) => Text(
                        value.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, _) => Text(
                        'Pt ${value.toInt()}',
                        style: const TextStyle(fontSize: 10),
                      ),
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $error'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  error = null;
                });
                _loadMetrics();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (allMetrics.isEmpty) {
      return const Center(child: Text('No metrics available'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              borderColor: Colors.transparent,
              selectedBorderColor: Colors.transparent,
              fillColor: Colors.teal,
              selectedColor: Colors.white,
              color: Colors.black87,
              constraints: const BoxConstraints(minHeight: 42, minWidth: 90),
              isSelected: [
                'Week',
                'Month',
                'Year',
              ].map((r) => r == selectedRange).toList(),
              onPressed: (i) {
                setState(() {
                  selectedRange = ['Week', 'Month', 'Year'][i];
                });
              },
              children: const [Text('Week'), Text('Month'), Text('Year')],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildChart(
                  'Weight Trend',
                  _getFilteredWeights(),
                  40,
                  100,
                  Colors.teal,
                  ranges: _getBmiRanges(),
                ),
                _buildChart(
                  'Sugar Level',
                  _getFilteredSugarLevels(),
                  80,
                  110,
                  Colors.orange,
                ),
                _buildChart(
                  'Water Intake',
                  _getFilteredWaterIntakes(),
                  1.5,
                  2.5,
                  Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
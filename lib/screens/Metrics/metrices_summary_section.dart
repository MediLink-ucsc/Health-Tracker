import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MetricsSummaryScreen extends StatefulWidget {
  const MetricsSummaryScreen({super.key});

  @override
  State<MetricsSummaryScreen> createState() => _MetricsSummaryScreenState();
}

class _MetricsSummaryScreenState extends State<MetricsSummaryScreen> {
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

  String selectedRange = 'Week';
  final double heightMeters = 1.70;

  List<num> _getFilteredData(List<double> data) {
    if (selectedRange == 'Week') {
      return data.take(7).toList().reversed.toList();
    } else if (selectedRange == 'Month') {
      return data.take(30).toList().reversed.toList();
    } else {
      return List.generate(12, (m) {
        final start = m * 30;
        final end = (start + 30).clamp(0, data.length);
        final slice = data.sublist(start, end);
        return slice.isNotEmpty
            ? slice.reduce((a, b) => a + b) / slice.length
            : 0;
      }).reversed.toList();
    }
  }

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
    final filtered = _getFilteredData(data);
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Prettier Toggle Buttons
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
                  allWeightData,
                  40,
                  100,
                  Colors.teal,
                  ranges: _getBmiRanges(),
                ),
                _buildChart(
                  'Sugar Level',
                  allSugarData,
                  80,
                  110,
                  Colors.orange,
                ),
                _buildChart(
                  'Water Intake',
                  allWaterData,
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
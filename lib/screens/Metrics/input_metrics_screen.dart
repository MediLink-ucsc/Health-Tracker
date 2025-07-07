import 'package:flutter/material.dart';
import 'package:health_tracker/screens/Metrics/record_metrices_section.dart';

import '../../Components/custom_bottom_nav.dart';
import 'metrices_summary_section.dart';

void main() {
  runApp(const MaterialApp(home: InputMetricScreen()));
}

class InputMetricScreen extends StatelessWidget {
  const InputMetricScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Health Metrics'),
          bottom: const TabBar(
            labelColor: Colors.white, // color of the selected tab text
            unselectedLabelColor:
                Colors.white70, // color of unselected tab text
            indicatorColor: Colors.amber, // optional: indicator underline color

            tabs: [
              Tab(text: 'Summary'),
              Tab(text: 'Input'),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
        body: const TabBarView(
          children: [MetricsSummaryScreen(), RecordMetricsScreen()],
        ),
      ),
    );
  }
}

// class MetricsSummaryScreen extends StatelessWidget {
//   const MetricsSummaryScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Summary Screen'));
//   }
// }
//
// class RecordMetricsScreen extends StatelessWidget {
//   const RecordMetricsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Input Screen'));
//   }
// }
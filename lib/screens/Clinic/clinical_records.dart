import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';

class ClinicalRecord {
  final DateTime date;
  final String doctor;
  final String clinic;
  final String diagnosis;
  final String medications;
  final String recommendations;

  ClinicalRecord({
    required this.date,
    required this.doctor,
    required this.clinic,
    required this.diagnosis,
    required this.medications,
    required this.recommendations,
  });
}

class ClinicalCalendarScreen extends StatefulWidget {
  const ClinicalCalendarScreen({super.key});

  @override
  State<ClinicalCalendarScreen> createState() => _ClinicalCalendarScreenState();
}

class _ClinicalCalendarScreenState extends State<ClinicalCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Sample clinical records
  final Map<DateTime, List<ClinicalRecord>> _records = {
    DateTime.utc(2025, 7, 6): [
      ClinicalRecord(
        date: DateTime.utc(2025, 7, 6),
        doctor: 'Dr. Fernando',
        clinic: 'Sunrise Clinic',
        diagnosis: 'Seasonal flu',
        medications: 'Paracetamol, Vitamin C',
        recommendations: 'Rest for 5 days',
      ),
    ],
    DateTime.utc(2025, 7, 3): [
      ClinicalRecord(
        date: DateTime.utc(2025, 7, 3),
        doctor: 'Dr. Silva',
        clinic: 'Wellcare Center',
        diagnosis: 'Back pain',
        medications: 'Painkillers, Physiotherapy',
        recommendations: 'Avoid lifting heavy objects',
      ),
    ],
  };

  List<ClinicalRecord> _getRecordsForDay(DateTime day) {
    return _records[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Visits'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('Logout'),
                      onPressed: () {
                        Navigator.pop(context);
                        appLogout(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
      body: Column(
        children: [
          TableCalendar<ClinicalRecord>(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              markerDecoration: const BoxDecoration(
                color: Colors.teal, // keep marker dot under dates
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                border: Border.all(color: Colors.orange, width: 2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0D9488), width: 2),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.black, // or any color you prefer
                fontWeight: FontWeight.bold,
              ),
            ),

            eventLoader: _getRecordsForDay,
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                _selectedDay == null || _getRecordsForDay(_selectedDay!).isEmpty
                ? const Center(child: Text('No clinical data on this day'))
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: _getRecordsForDay(_selectedDay!).map((record) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.doctor,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Clinic: ${record.clinic}'),
                              Text('Diagnosis: ${record.diagnosis}'),
                              Text('Medications: ${record.medications}'),
                              Text(
                                'Recommendations: ${record.recommendations}',
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
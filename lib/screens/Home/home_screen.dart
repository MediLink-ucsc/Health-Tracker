import 'package:flutter/material.dart';
import 'package:health_tracker/Components/logout.dart';

import '../../Components/custom_bottom_nav.dart';
import '../Profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    const accentColor = Color(0xFFF1BE26);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tracker'),
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
      backgroundColor: Colors.white,

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Handle Add button tap (e.g., open metrics input)
      //   },
      //   backgroundColor: primaryColor,
      //   elevation: 4,
      //   child: const Icon(Icons.add, size: 32),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting & Profile
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,

                    backgroundColor: Color(0xFF0D9488),
                    backgroundImage: AssetImage('assets/icon/user_2.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Hello Anjula',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Welcome back to Health Tracker!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    color: primaryColor,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Family Member Card
              Card(
                color: const Color(0xFFE0F2F1),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.analytics, color: accentColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Last Recorded Activity',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Blood Sugar: 120 mg/dL',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Date: 2025-07-07',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Quick Access Section
              const Text(
                'Quick Access',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.9,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _QuickAccessItem(
                    label: 'Lab Reports',
                    iconAsset: 'assets/icon/lab_report_2.png',
                  ),
                  _QuickAccessItem(
                    label: 'Clinics',
                    iconAsset: 'assets/icon/clinic_2.png',
                  ),
                  _QuickAccessItem(
                    label: 'My Profile',
                    iconAsset: 'assets/icon/profile_2.png',
                  ),
                  _QuickAccessItem(
                    label: 'Stats View',
                    iconAsset: 'assets/icon/stats_2.png',
                  ),
                  _QuickAccessItem(
                    label: 'Input Metrics',
                    iconAsset: 'assets/icon/input_2.png',
                  ),
                  // _QuickAccessItem(
                  //   label: 'Family Data',
                  //   iconAsset: 'assets/icon/family_2.png',
                  // ),
                ],
              ),
              const SizedBox(height: 28),

              // Spotlight Section
              const Text(
                'Spotlight',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '#Reminder',
                            style: TextStyle(color: Color(0xFFEA580C)),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Upcoming Clinic Visit\nat MediCare Hospital',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'View Appointment Details',
                            style: TextStyle(
                              color: primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.calendar_month, size: 48, color: primaryColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Quick Access Item Widget
class _QuickAccessItem extends StatelessWidget {
  final String label;
  final String iconAsset;

  const _QuickAccessItem({required this.label, required this.iconAsset});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF9F9F9),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconAsset, height: 50, width: 50),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
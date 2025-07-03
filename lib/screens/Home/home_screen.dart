import 'package:flutter/material.dart';

import '../Profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    const accentColor = Color(0xFFEA580C);

    return Scaffold(
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
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE0F2F1),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: primaryColor,
              iconSize: 28,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.assignment),
              color: Colors.grey.shade700,
              iconSize: 28,
              onPressed: () {},
            ),
            // Empty space for the notch
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.local_hospital),
              color: Colors.grey.shade700,
              iconSize: 28,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: Colors.grey.shade700,
              iconSize: 28,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle Add button tap
        },
        backgroundColor: primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, size: 28), // SAME SIZE as other icons
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

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
                    backgroundImage: AssetImage('assets/icon/female_user.png'),
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
                    children: [
                      Icon(Icons.person, color: accentColor),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thiran Sasanka',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text('Wife'),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'STL1234A',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Last Recorded Activity Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'Last Recorded Activity',
                    items: const [
                      DropdownMenuItem(
                        value: 'Last Recorded Activity',
                        child: Text('Last Recorded Activity'),
                      ),
                      DropdownMenuItem(
                        value: 'Activity 1',
                        child: Text('Activity 1'),
                      ),
                      DropdownMenuItem(
                        value: 'Activity 2',
                        child: Text('Activity 2'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ),
              const SizedBox(height: 28),

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
                  _QuickAccessItem(
                    label: 'Family Data',
                    iconAsset: 'assets/icon/family_2.png',
                  ),
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
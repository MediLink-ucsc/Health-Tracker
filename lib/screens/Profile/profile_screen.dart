import 'package:flutter/material.dart';

import '../Home/home_screen.dart';
import 'edit_profile_screen.dart'; // import your edit profile screen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    const accentColor = Color(0xFFEA580C);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: primaryColor,
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE0F2F1),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),

              color: Colors.grey.shade700,
              iconSize: 28,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.assignment),
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
            // Empty space for the notch
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.local_hospital),
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
            IconButton(
              icon: const Icon(Icons.person),
              color: primaryColor,
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
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28), // SAME SIZE as other icons
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Full Name
            const Text(
              'Anjula Himashi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Basic Details
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.cake, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('Age: 24'),
                SizedBox(width: 16),
                Icon(Icons.male, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('Female'),
              ],
            ),
            const SizedBox(height: 16),

            // Blood Group
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.bloodtype, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('Blood Group: O-'),
              ],
            ),

            const SizedBox(height: 24),

            // Other Details Card
            Card(
              color: const Color(0xFFE0F2F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    _DetailRow(label: 'Phone', value: '074 079 4161'),
                    Divider(),
                    _DetailRow(
                      label: 'Email',
                      value: 'anjulahimashi1@gmail.com',
                    ),
                    Divider(),
                    _DetailRow(label: 'Address', value: 'Colombo, Sri Lanka'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Emergency Contact Card
            Card(
              // color: accentColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    _DetailRow(label: 'Name', value: 'Thiran Sasanka'),
                    Divider(),
                    _DetailRow(label: 'Relation', value: 'Bro'),
                    Divider(),
                    _DetailRow(
                      label: 'Contact Number',
                      value: '+94 77 9876543',
                    ),
                    Divider(),
                    _DetailRow(
                      label: 'Emergency Notes',
                      value: 'Asthma since childhood',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable detail row widget
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}
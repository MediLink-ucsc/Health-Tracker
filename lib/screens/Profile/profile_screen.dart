import 'package:flutter/material.dart';
import 'package:health_tracker/screens/user_login_screen.dart';

import '../../Components/custom_bottom_nav.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    const accentColor = Color(0xFFF1BE26);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
                        _logout(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Avatar
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor.withOpacity(0.2),
                    backgroundImage: const AssetImage('assets/icon/user_2.png'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Anjula Himashi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cake, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Age: 24'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.female, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Female'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.bloodtype, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Blood Group: O-'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.height, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Height: 153cm'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Contact Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.phone, label: 'Phone', value: '074 079 4161'),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.email,
              label: 'Email',
              value: 'anjulahimashi1@gmail.com',
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.location_on,
              label: 'Address',
              value: 'Colombo, Sri Lanka',
            ),
            const SizedBox(height: 24),

            const Text(
              'Emergency Contact',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.person,
              label: 'Name',
              value: 'Thiran Sasanka',
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.group, label: 'Relation', value: 'Brother'),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.phone_android,
              label: 'Contact',
              value: '+94 77 9876543',
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.note,
              label: 'Notes',
              value: 'Asthma since childhood',
            ),
            const SizedBox(height: 32),

            Center(
              child: ElevatedButton.icon(
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            // Inside the Column after Edit Profile button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Confirm before logout
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
                            Navigator.pop(context); // Close the dialog
                            _logout(context); // Call logout
                          },
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Flat style info row without divider
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 8),
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

void _logout(BuildContext context) {
  // Example: Navigate to login screen and clear stack
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const UserLoginScreen()),
    (route) => false,
  );
}
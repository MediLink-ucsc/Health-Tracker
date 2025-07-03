import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    const accentColor = Color(0xFFEA580C);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: primaryColor.withOpacity(0.95),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Basic Info
            TextFormField(
              initialValue: 'Anjula Himashi',
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextFormField(
              initialValue: '24',
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              initialValue: 'Male',
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            TextFormField(
              initialValue: 'O+',
              decoration: const InputDecoration(labelText: 'Blood Group'),
            ),
            const SizedBox(height: 16),
            // Contact Info
            TextFormField(
              initialValue: '+94 77 1234567',
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextFormField(
              initialValue: 'anjula@example.com',
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              initialValue: 'Colombo, Sri Lanka',
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            // Emergency Contact
            const Text(
              'Emergency Contact',
              style: TextStyle(fontWeight: FontWeight.bold, color: accentColor),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: 'Thiran Sasanka',
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              initialValue: 'Wife',
              decoration: const InputDecoration(labelText: 'Relation'),
            ),
            TextFormField(
              initialValue: '+94 77 9876543',
              decoration: const InputDecoration(labelText: 'Contact Number'),
            ),
            const SizedBox(height: 16),
            // Emergency Notes
            TextFormField(
              initialValue: 'Asthma since childhood',
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Emergency Notes',
                hintText:
                    'E.g., Allergies, chronic illnesses, special considerations',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
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
import 'package:flutter/material.dart';

class UserTypeScreen extends StatefulWidget {
  @override
  _UserTypeScreenState createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _userType; // "self" or "caregiver"

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty || _userType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name and select user type')),
      );
      return;
    }
    print('Name: $name, UserType: $_userType');
    // Add navigation or logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Who are you?')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          // Center vertically and horizontally
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // shrink wrap content vertically
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter your name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                Text('Are you using the app for yourself or for someone else?'),
                ListTile(
                  title: Text('I am using it for myself'),
                  leading: Radio<String>(
                    value: 'self',
                    groupValue: _userType,
                    onChanged: (value) {
                      setState(() {
                        _userType = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('I am a caregiver using it for someone else'),
                  leading: Radio<String>(
                    value: 'caregiver',
                    groupValue: _userType,
                    onChanged: (value) {
                      setState(() {
                        _userType = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, // button fills width of parent container
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20), // more height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:health_tracker/screens/user_login_screen.dart';

class UserSigningScreen extends StatefulWidget {
  @override
  _UserSigningScreenState createState() => _UserSigningScreenState();
}

class _UserSigningScreenState extends State<UserSigningScreen> {
  // Controllers
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Step and state
  int _step = 2; // Starts from Phone step
  bool _otpSent = false;
  bool _otpVerified = false;

  // Other selections
  String? _userType;
  String? _gender;
  String? _bloodType;
  String? _height;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step == 2) {
      if (!_otpSent) {
        // Send OTP
        if (_phoneController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter phone number')),
          );
          return;
        }
        setState(() {
          _otpSent = true;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('OTP sent to your phone')));
      } else {
        // Proceed to OTP verification step
        setState(() {
          _step = 3;
        });
      }
    } else if (_step == 3) {
      if (_otpController.text.trim() == '1234') {
        setState(() {
          _otpVerified = true;
          _step = 4;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Phone verified')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
      }
    } else if (_step == 4) {
      if (!_formKey.currentState!.validate()) return;
      _submit();
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final phone = _phoneController.text.trim();

    print(
      'Signed Up Info:\n'
      'Name: $name\n'
      'Age: $age\n'
      'Phone: $phone\n'
      'Height: $_height\n'
      'Blood Type: $_bloodType\n'
      'Gender: $_gender\n'
      'User Type: $_userType',
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Registration complete!')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserLoginScreen()),
    );
  }

  // Phone input step
  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter your phone number:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
          ),
        ),
      ],
    );
  }

  // OTP input step
  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter the OTP:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'OTP',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ],
    );
  }

  // Details input step
  Widget _buildDetailsStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
            ),
            validator: (value) {
              if (value == null || int.tryParse(value.trim()) == null) {
                return 'Enter a valid age';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Height (cm) - optional',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
            ),
            onChanged: (val) => _height = val,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Blood Type (optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
            ),
            items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (val) => _bloodType = val,
          ),
          const SizedBox(height: 16),
          const Text("Gender:"),
          ListTile(
            title: const Text("Male"),
            leading: Radio<String>(
              value: "Male",
              groupValue: _gender,
              onChanged: (val) => setState(() => _gender = val),
            ),
          ),
          ListTile(
            title: const Text("Female"),
            leading: Radio<String>(
              value: "Female",
              groupValue: _gender,
              onChanged: (val) => setState(() => _gender = val),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_step == 2) {
      content = _buildPhoneStep();
    } else if (_step == 3) {
      content = _buildOtpStep();
    } else {
      content = _buildDetailsStep();
    }

    // Set dynamic button text
    String buttonText;
    if (_step == 2) {
      buttonText = _otpSent ? 'Next' : 'Send OTP';
    } else if (_step == 3) {
      buttonText = 'Verify OTP';
    } else {
      buttonText = 'Submit';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFFF5F7F9),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [content],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade700,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }
}
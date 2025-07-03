import 'package:flutter/material.dart';

class UserSigningScreen extends StatefulWidget {
  @override
  _UserSigningScreenState createState() => _UserSigningScreenState();
}

class _UserSigningScreenState extends State<UserSigningScreen> {
  String? _userType; // "self" or "caregiver"
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  int _step = 1; // 1=userType, 2=email, 3=name+age if needed

  bool _emailRegistered = false; // simulate email check

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step == 1) {
      if (_userType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select user type')),
        );
        return;
      }
      setState(() {
        _step = 2;
      });
    } else if (_step == 2) {
      final email = _emailController.text.trim();
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (email.isEmpty || !emailRegex.hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email address')),
        );
        return;
      }

      // Simulate email check - here: emails with "test" are registered
      if (email.contains("test")) {
        _emailRegistered = true;
        // Proceed to submit directly
        _submit(registeredUser: true);
      } else {
        // Email NOT registered, ask for name and age
        _emailRegistered = false;
        setState(() {
          _step = 3;
        });
      }
    } else if (_step == 3) {
      if (!_formKey.currentState!.validate()) return;
      _submit(registeredUser: false);
    }
  }

  void _submit({required bool registeredUser}) {
    final email = _emailController.text.trim();
    final userType = _userType ?? '';

    if (registeredUser) {
      // For registered users, just print info and proceed
      print('Registered user: Email: $email, UserType: $userType');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));
      // Navigate or further logic here
    } else {
      // For new user, get name and age
      final name = _nameController.text.trim();
      final age = _ageController.text.trim();
      final firstName = name.split(' ').first;

      print(
        'New user info: Name: $name,First Name: $firstName, Age: $age, Email: $email, UserType: $userType',
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful!')));
      // Navigate or further logic here
    }
  }

  Widget _buildUserTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Are you using the app for yourself or for someone else?',
          style: TextStyle(fontSize: 18),
        ),
        ListTile(
          title: const Text('I am using it for myself'),
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
          title: const Text('I am a caregiver using it for someone else'),
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
      ],
    );
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your email address: ',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ],
    );
  }

  Widget _buildNameAgeStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'It looks like your email is not registered yet. Please enter your details:',
          //   style: TextStyle(fontSize: 18),
          // ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
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
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your age';
              }
              if (int.tryParse(value.trim()) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_step == 1) {
      content = _buildUserTypeStep();
    } else if (_step == 2) {
      content = _buildEmailStep();
    } else {
      content = _buildNameAgeStep();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('User Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(child: content),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _nextStep,
            child: Text(
              _step == 3 || (_step == 2 && _emailRegistered)
                  ? 'Submit'
                  : 'Next',
            ),
          ),
        ),
      ),
    );
  }
}
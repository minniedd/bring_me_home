import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/user.dart';
import 'package:bringmehome_admin/services/user_provider.dart';
import 'package:flutter/material.dart';

class EditUserScreen extends StatefulWidget {
  final User user;
  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final UserProvider _userProvider = UserProvider();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _isActiveController;

  @override
void initState() {
  super.initState();
     _firstNameController = TextEditingController();
     _lastNameController = TextEditingController();
     _emailController = TextEditingController();
     _usernameController = TextEditingController();
     _phoneNumberController = TextEditingController();
     _addressController = TextEditingController();
     _isActiveController = TextEditingController();


  _firstNameController = TextEditingController(text: widget.user.firstName);
  _lastNameController = TextEditingController(text: widget.user.lastName);
  _emailController = TextEditingController(text: widget.user.email);
  _usernameController = TextEditingController(text: widget.user.username);
  _phoneNumberController = TextEditingController(text: widget.user.phoneNumber ?? '');
  _addressController = TextEditingController(text: widget.user.address ?? '');
  _isActiveController = TextEditingController(text: widget.user.isActive.toString());
}

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _isActiveController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?(?:[0-9]|-){10,15}$').hasMatch(phone);
  }

  void _confirmChanges() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please correct the errors in the form.'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    Map<String, dynamic> updateRequestData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'username': _usernameController.text,
      'phoneNumber': _phoneNumberController.text.isEmpty ? null : _phoneNumberController.text,
      'address': _addressController.text.isEmpty ? null : _addressController.text,
      'isActive': _isActiveController.text.toLowerCase() == "true",
    };

    updateRequestData.removeWhere(
        (key, value) => value == null || (value is String && value.isEmpty));

    try {
      User result = await _userProvider.updateUser(
        widget.user.id!,
        updateRequestData,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User "${result.firstName} ${result.lastName}" has been updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error updating user: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: "Edit User",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the e-mail';
                  }
                  if (!_isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (e.g 123-456-780)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !_isValidPhoneNumber(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Account Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the username';
                  }
                  if (value.length < 4) {
                    return 'Username must be at least 4 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _isActiveController,
                decoration: const InputDecoration(
                  labelText: 'Is Active (true/false)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please specify if the user is active';
                  }
                  if (value.toLowerCase() != 'true' &&
                      value.toLowerCase() != 'false') {
                    return 'Please enter "true" or "false"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _confirmChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Changes'),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

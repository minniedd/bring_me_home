import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_app/models/user.dart';
import 'package:learning_app/providers/user_provider.dart';
import 'package:learning_app/widgets/master_screen.dart';
import 'package:dotted_border/dotted_border.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProvider _userProvider = UserProvider();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  User? _currentUser;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  String? _base64Image;


  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = await _userProvider.loadCurrentUser();
      if (user != null) {
        setState(() {
          _currentUser = user;
          _loadUserInfo();
          if (_currentUser!.userImage != null && _currentUser!.userImage!.isNotEmpty) {
            _base64Image = _currentUser!.userImage;
          }
        });
      } else {
        _showErrorMessage('Failed to load user profile');
      }
    } catch (e) {
      _showErrorMessage('Error loading profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(imageBytes);
      });
    }
  }

  void _loadUserInfo() {
    if (_currentUser != null) {
      _usernameController.text = _currentUser!.username;
      _firstNameController.text = _currentUser!.firstName;
      _lastNameController.text = _currentUser!.lastName;
      _emailController.text = _currentUser!.email;
      _phoneController.text = _currentUser!.phoneNumber ?? '';
      _addressController.text = _currentUser!.address ?? '';
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final userData = {
        'username': _usernameController.text.trim(),
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'userImage': _base64Image,
      };

      final updatedUser = await _userProvider.updateProfile(userData);
      setState(() {
        _currentUser = updatedUser;
        _isEditing = false;
      });

      _showSuccessMessage('Profile updated successfully!');
    } catch (e) {
      _showErrorMessage('Failed to update profile: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _loadUserInfo();
      if (_currentUser!.userImage != null && _currentUser!.userImage!.isNotEmpty) {
        _base64Image = _currentUser!.userImage;
      } else {
        _base64Image = null;
      }
    });
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      settingsIcon: false,
      titleText:
          "profile of ${_currentUser?.firstName} ${_currentUser?.lastName}"
              .toUpperCase(),
      child: Container(
        margin: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _currentUser == null
                ? const Center(child: Text('No user data available'))
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(176, 139, 215, 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                              CircleAvatar(
                                  radius: 50,
                                  backgroundColor: const Color.fromRGBO(176, 139, 215, 1),
                                  child: ClipOval(
                                    child: _base64Image != null && _base64Image!.isNotEmpty
                                        ? Image.memory(
                                            base64Decode(_base64Image!),
                                            width: 94,
                                            height: 94,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.white70,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.white70,
                                          ),
                                  ),
                                ),
                                if (_isEditing)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: DottedBorder(
                                      color: const Color.fromRGBO(176, 139, 215, 1),
                                      strokeWidth: 1,
                                      dashPattern: const [6, 3],
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: TextButton.icon(
                                          onPressed: _pickImage,
                                          icon: const Icon(Icons.camera_alt, size: 20),
                                          label: const Text('Change Photo'),
                                          style: TextButton.styleFrom(
                                            foregroundColor: const Color.fromRGBO(176, 139, 215, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                Text(
                                  '${_currentUser!.firstName} ${_currentUser!.lastName}'
                                      .trim(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _currentUser!.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!_isEditing)
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      setState(() => _isEditing = true),
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit Profile'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(176, 139, 215, 1),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              if (_isEditing) ...[
                                ElevatedButton.icon(
                                  onPressed: _cancelEdit,
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Cancel'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: _isSaving ? null : _saveProfile,
                                  icon: _isSaving
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : const Icon(Icons.save),
                                  label:
                                      Text(_isSaving ? 'Saving...' : 'Save'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(176, 139, 215, 1),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildFormField(
                            controller: _usernameController,
                            label: 'Username',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Username is required';
                              }
                              return null;
                            },
                          ),
                          _buildFormField(
                            controller: _firstNameController,
                            label: 'First Name',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'First name is required';
                              }
                              return null;
                            },
                          ),
                          _buildFormField(
                            controller: _lastNameController,
                            label: 'Last Name',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Last name is required';
                              }
                              return null;
                            },
                          ),
                          _buildFormField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          _buildFormField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                          ),
                          _buildFormField(
                            controller: _addressController,
                            label: 'Address',
                            icon: Icons.location_on,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color.fromRGBO(176, 139, 215, 1)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          filled: true,
          fillColor: _isEditing ? Colors.white : Colors.grey[50],
        ),
      ),
    );
  }
}
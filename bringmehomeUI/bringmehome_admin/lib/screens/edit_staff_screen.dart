import 'package:bringmehome_admin/components/image_picker.dart';
import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/city.dart';
import 'package:bringmehome_admin/models/shelter.dart';
import 'package:bringmehome_admin/models/staff.dart';
import 'package:bringmehome_admin/models/user.dart';
import 'package:bringmehome_admin/services/city_provider.dart';
import 'package:bringmehome_admin/services/shelter_provider.dart';
import 'package:bringmehome_admin/services/staff_provider.dart';
import 'package:bringmehome_admin/services/user_provider.dart';
import 'package:bringmehome_admin/services/user_staff_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class EditStaffScreen extends StatefulWidget {
  final Staff staff;

  const EditStaffScreen({super.key, required this.staff});

  @override
  State<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends State<EditStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late UserStaffProvider _userStaffProvider;
  final CityProvider _cityProvider = CityProvider();
  final ShelterProvider _shelterProvider = ShelterProvider();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _passwordController;
  late TextEditingController _positionController;
  late TextEditingController _departmentController;
  late TextEditingController _statusController;

  late DateTime _hireDate;
  late int _accessLevel;
  int? _selectedCityId;
  int? _selectedShelterId;
  String? _selectedStatus;

  List<City> _cities = [];
  bool _isLoadingCity = true;

  List<Shelter> _shelters = [];
  bool _isLoadingShelters = true;

  User? _currentUser;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    _userStaffProvider = UserStaffProvider(
      userProvider: UserProvider(),
      staffProvider: StaffProvider(),
    );
    _initializeControllers();
    _loadData();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _passwordController = TextEditingController();
    _positionController = TextEditingController(text: widget.staff.position);
    _departmentController =
        TextEditingController(text: widget.staff.department);
    _statusController = TextEditingController(text: widget.staff.status);

    _hireDate = widget.staff.hireDate;
    _accessLevel = widget.staff.accessLevel;
    _selectedShelterId = widget.staff.shelterID;
    _selectedStatus = widget.staff.status;
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _isLoadingCity = true;
      _isLoadingShelters = true;
    });
    try {
      _currentUser = await UserProvider().getById(widget.staff.userID);
      _cities = await _cityProvider.getCities();
      _shelters = await _shelterProvider.getShelters();

      if (_currentUser != null) {
        _firstNameController.text = _currentUser!.firstName;
        _lastNameController.text = _currentUser!.lastName;
        _emailController.text = _currentUser!.email;
        _usernameController.text = _currentUser!.username;
        _phoneController.text = _currentUser!.phoneNumber ?? '';
        _addressController.text = _currentUser!.address ?? '';
        _imageBase64 = _currentUser!.userImage;

        if (_currentUser!.cityID != null) {
          final foundCity = _cities.firstWhere(
            (city) => city.cityID == _currentUser!.cityID,
            orElse: () => City(cityID: -1, cityName: ''),
          );
          if (foundCity.cityID != -1) {
            _selectedCityId = foundCity.cityID;
          } else {
            _selectedCityId = null;
          }
        } else {
          _selectedCityId = null;
        }
      }
    } catch (e) {
      if (mounted) {
        if (kDebugMode) print('Error loading data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCity = false;
          _isLoadingShelters = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final updatedUser = User(
          id: _currentUser!.id,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          username: _usernameController.text,
          phoneNumber:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
          address: _addressController.text.isNotEmpty
              ? _addressController.text
              : null,
          cityID: _selectedCityId,
          isActive: _currentUser!.isActive,
          createdAt: _currentUser!.createdAt,
        );

        await _userStaffProvider.updateStaffWithUser(
          staffId: widget.staff.staffID,
          userId: widget.staff.userID,
          user: updatedUser,
          password: _passwordController.text.isNotEmpty
              ? _passwordController.text
              : null,
          position: _positionController.text,
          department: _departmentController.text,
          shelterID: _selectedShelterId!,
          hireDate: _hireDate,
          status: _selectedStatus ?? '',
          accessLevel: _accessLevel,
          userImage: _imageBase64,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Staff member updated successfully!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          if (kDebugMode) print('Error updating staff: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating staff: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
      }
    }
  }

  InputDecoration _getInputDecoration(String labelText,
      {IconData? icon, bool isRequired = true}) {
    return InputDecoration(
      labelText: isRequired ? '$labelText *' : labelText,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey[600]) : null,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildSectionTitle(String title, {IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      backButton: true,
      titleText: 'Edit Staff'.toUpperCase(),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSectionTitle('User Information',
                            icon: Icons.person),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: _getInputDecoration('First Name',
                              icon: Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: _getInputDecoration('Last Name',
                              icon: Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: _getInputDecoration('Email',
                              icon: Icons.email_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _usernameController,
                          decoration: _getInputDecoration('Username',
                              icon: Icons.account_circle_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                            controller: _phoneController,
                            decoration: _getInputDecoration('Phone Number',
                                icon: Icons.phone_outlined,
                                isRequired: false),
                            validator: null),
                        const SizedBox(height: 16),
                        TextFormField(
                            controller: _addressController,
                            decoration: _getInputDecoration('Address',
                                icon: Icons.home_outlined, isRequired: false),
                            validator: null),
                        const SizedBox(height: 16),
                        _isLoadingCity
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<int>(
                                decoration: _getInputDecoration('City',
                                    icon: Icons.location_city_outlined),
                                value: _selectedCityId,
                                hint: const Text('Select City'),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                items: _cities.map((City city) {
                                  return DropdownMenuItem<int>(
                                    value: city.cityID,
                                    child: Text(city.cityName),
                                  );
                                }).toList(),
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedCityId = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a city';
                                  }
                                  return null;
                                },
                              ),
                        const SizedBox(height: 16),
                        _isLoadingShelters
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<int>(
                                decoration: _getInputDecoration('Shelter',
                                    icon: Icons.home_work_outlined),
                                value: _selectedShelterId,
                                hint: const Text('Select Shelter'),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                items: _shelters.map((Shelter shelter) {
                                  return DropdownMenuItem<int>(
                                    value: shelter.shelterID,
                                    child: Text(shelter.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedShelterId = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a shelter';
                                  }
                                  return null;
                                },
                              ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: _getInputDecoration(
                            'New Password',
                            icon: Icons.lock_outline,
                            isRequired: false,
                          ).copyWith(
                            helperText: 'Leave blank if not changing',
                          ),
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.image_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Profile Image',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: ImagePickerWidget(
                                  initialImageBase64: _imageBase64,
                                  onImageChanged: (newBase64) {
                                    setState(() {
                                      _imageBase64 = newBase64;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildSectionTitle('Staff Information',
                            icon: Icons.work_outline),
                        TextFormField(
                          controller: _positionController,
                          decoration: _getInputDecoration('Position',
                              icon: Icons.work_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter position';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _departmentController,
                          decoration: _getInputDecoration('Department',
                              icon: Icons.business_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter department';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.calendar_today,
                                color: Colors.grey[600], size: 20),
                            title: Text(
                              'Hire Date *',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.3,
                              ),
                            ),
                            subtitle: Text(
                              '${_hireDate.year}-${_hireDate.month.toString().padLeft(2, '0')}-${_hireDate.day.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Icon(Icons.edit,
                                color: Theme.of(context).colorScheme.primary),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _hireDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null && picked != _hireDate) {
                                setState(() {
                                  _hireDate = picked;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: _getInputDecoration('Status',
                              icon: Icons.info_outline),
                          value: _selectedStatus,
                          dropdownColor: Colors.white,
                          items: const [
                            DropdownMenuItem(
                                value: 'Active', child: Text('Active')),
                            DropdownMenuItem(
                                value: 'Inactive', child: Text('Inactive')),
                            DropdownMenuItem(
                                value: 'On Leave', child: Text('On Leave')),
                            DropdownMenuItem(
                                value: 'Terminated',
                                child: Text('Terminated')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select status';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          decoration: _getInputDecoration('Access Level',
                              icon: Icons.security_outlined),
                          value: _accessLevel,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          items: const [
                            DropdownMenuItem(
                                value: 1, child: Text('Level 1 - Basic')),
                            DropdownMenuItem(
                                value: 2, child: Text('Level 2 - Standard')),
                            DropdownMenuItem(
                                value: 3, child: Text('Level 3 - Admin')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _accessLevel = value!;
                            });
                          },
                          validator: (value) {
                             if (value == null) {
                              return 'Please select an access level';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'Update Staff',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
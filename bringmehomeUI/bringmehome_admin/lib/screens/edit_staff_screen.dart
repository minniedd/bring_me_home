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

  List<City> _cities = [];
  bool _isLoadingCity = true;

  List<Shelter> _shelters = [];
  bool _isLoadingShelters = true;

  User? _currentUser;

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
          phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
          address: _addressController.text.isNotEmpty ? _addressController.text : null,
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
          status: _statusController.text,
          accessLevel: _accessLevel,
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: 'Edit Staff'.toUpperCase(),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'User Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _isLoadingCity
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedCityId,
                            hint: const Text('Select City'),
                            isExpanded: true,
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
                    const SizedBox(height: 12),
                    _isLoadingShelters
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'Shelter',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedShelterId,
                            hint: const Text('Select Shelter'),
                            isExpanded: true,
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'New Password (leave blank if not changing)',
                        border: OutlineInputBorder(),
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
                    const Text(
                      'Staff Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _positionController,
                      decoration: const InputDecoration(
                        labelText: 'Position',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter position';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _departmentController,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter department';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: const Text('Hire Date'),
                      subtitle: Text(
                        '${_hireDate.year}-${_hireDate.month.toString().padLeft(2, '0')}-${_hireDate.day.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _statusController,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter status';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Access Level',
                        border: OutlineInputBorder(),
                      ),
                      value: _accessLevel,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Level 1 - Basic')),
                        DropdownMenuItem(value: 2, child: Text('Level 2 - Standard')),
                        DropdownMenuItem(value: 3, child: Text('Level 3 - Admin')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _accessLevel = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text('Update Staff'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
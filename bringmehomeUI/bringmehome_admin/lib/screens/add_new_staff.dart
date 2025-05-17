import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/city.dart';
import 'package:bringmehome_admin/models/shelter.dart';
import 'package:bringmehome_admin/services/city_provider.dart';
import 'package:bringmehome_admin/services/shelter_provider.dart';
import 'package:bringmehome_admin/services/staff_provider.dart';
import 'package:bringmehome_admin/services/user_provider.dart';
import 'package:flutter/material.dart';

class AddNewStaffScreen extends StatefulWidget {
  const AddNewStaffScreen({super.key});

  @override
  State<AddNewStaffScreen> createState() => _AddNewStaffScreenState();
}

class _AddNewStaffScreenState extends State<AddNewStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final StaffProvider _staffProvider = StaffProvider();
  final UserProvider _userProvider = UserProvider();
  final CityProvider _cityProvider = CityProvider();
  final ShelterProvider _shelterProvider = ShelterProvider();
  int _accessLevel = 1;

  List<City> _cities = [];
  int? _selectedCityId;
  bool _isLoadingCity = true;

  List<Shelter> _shelters = [];
  int? _selectedShelterId;
  bool _isLoadingShelters = true;

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadShelters();
  }

  Future<void> _loadCities() async {
    setState(() => _isLoadingCity = true);
    try {
      _cities = await _cityProvider.getCities();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load cities: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingCity = false);
    }
  }

  Future<void> _loadShelters() async {
    setState(() => _isLoadingShelters = true);
    try {
      _shelters = await _shelterProvider.getShelters();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load shelters: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingShelters = false);
    }
  }

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  DateTime _hireDate = DateTime.now();

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
    if (_formKey.currentState!.validate() &&
        _selectedCityId != null &&
        _selectedShelterId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userResponse = await _userProvider.insert({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'username': _usernameController.text,
          'phoneNumber': _phoneController.text,
          'address': _addressController.text,
          'cityID': _selectedCityId,
          'password': _passwordController.text,
          'isActive': true,
        });

        await _staffProvider.insert({
          'userID': userResponse.id,
          'position': _positionController.text,
          'department': _departmentController.text,
          'shelterID': _selectedShelterId,
          'hireDate': _hireDate.toIso8601String(),
          'status': _statusController.text,
          'accessLevel': _accessLevel,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Staff member created successfully!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating staff: $e')),
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
      titleText: 'Add new staff'.toUpperCase(),
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
                            onChanged: (value) {
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
                                _selectedShelterId = value;
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
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 6) {
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
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text('Create User and Add to Staff'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

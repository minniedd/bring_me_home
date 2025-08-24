import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/shelter.dart';
import 'package:bringmehome_admin/services/event_provider.dart';
import 'package:bringmehome_admin/services/shelter_provider.dart';
import 'package:flutter/material.dart';

class EventAddScreen extends StatefulWidget {
  const EventAddScreen({super.key});

  @override
  State<EventAddScreen> createState() => _EventAddScreenState();
}

class _EventAddScreenState extends State<EventAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final EventProvider _eventProvider = EventProvider();
  final ShelterProvider _shelterProvider = ShelterProvider();
  DateTime _eventDate = DateTime.now();
  Shelter? _selectedShelter;
  List<Shelter> _shelters = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadShelters();
  }

  Future<void> _loadShelters() async {
    try {
      final shelters = await _shelterProvider.get();
      setState(() {
        _shelters = shelters.result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load shelters: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedShelter == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a shelter.')),
        );
        return;
      }

      final newEvent = {
        'eventName': _eventNameController.text,
        'eventDate': _eventDate.toIso8601String(),
        'location': _locationController.text,
        'description': _descriptionController.text,
        'shelterID': _selectedShelter!.shelterID,
      };

      try {
        await _eventProvider.addEvent(newEvent);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event added successfully!')),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add event: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterScreenWidget(
        backButton: true,
        titleText: 'ADD NEW EVENT',
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          _buildTextField(
                            controller: _eventNameController,
                            label: 'Event Name',
                            validator: (value) =>
                                value!.isEmpty ? 'Event Name cannot be empty' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _locationController,
                            label: 'Location',
                            validator: (value) =>
                                value!.isEmpty ? 'Location cannot be empty' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _descriptionController,
                            label: 'Description',
                            maxLines: 4,
                            validator: (value) =>
                                value!.isEmpty ? 'Description cannot be empty' : null,
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            title: Text(
                              'Event Date: ${_eventDate.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(
                                  color: Color.fromRGBO(82, 59, 121, 1)),
                            ),
                            trailing: const Icon(Icons.calendar_today,
                                color: Color.fromRGBO(149, 117, 205, 1)),
                            onTap: () => _selectDate(context),
                          ),
                          const SizedBox(height: 16),
                          _buildShelterDropdown(),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(149, 117, 205, 1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _saveEvent,
                            child: const Text('Add Event'),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildShelterDropdown() {
    return DropdownButtonFormField<Shelter>(
      decoration: InputDecoration(
        labelText: 'Select Shelter',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      value: _selectedShelter,
      items: _shelters.map((shelter) {
        return DropdownMenuItem(
          value: shelter,
          child: Text(shelter.name),
        );
      }).toList(),
      onChanged: (Shelter? newValue) {
        setState(() {
          _selectedShelter = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a shelter' : null,
    );
  }
}
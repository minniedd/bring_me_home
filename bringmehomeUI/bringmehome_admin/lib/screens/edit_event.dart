import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/event.dart';
import 'package:bringmehome_admin/models/shelter.dart';
import 'package:bringmehome_admin/services/event_provider.dart';
import 'package:bringmehome_admin/services/shelter_provider.dart';
import 'package:flutter/material.dart';

class EventEditScreen extends StatefulWidget {
  final Event event;

  const EventEditScreen({super.key, required this.event});

  @override
  State<EventEditScreen> createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  final EventProvider _eventProvider = EventProvider();
  final ShelterProvider _shelterProvider = ShelterProvider();

  List<Shelter> _shelters = [];
  Shelter? _selectedShelter;
  DateTime? _eventDate;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _populateFields();
    _loadInitialData();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _populateFields() {
    _eventNameController.text = widget.event.eventName;
    _locationController.text = widget.event.location;
    _descriptionController.text = widget.event.description;
    _eventDate = widget.event.eventDate;
  }

  Future<void> _loadInitialData() async {
    try {
      final shelters = await _shelterProvider.get();

      setState(() {
        _shelters = shelters.result;
        _selectedShelter = _shelters.firstWhere(
            (s) => s.shelterID == widget.event.shelterID,
            orElse: () => _shelters.first);
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
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(149, 117, 205, 1),
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedShelter == null || _eventDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select both a shelter and an event date.')),
        );
        return;
      }

      final updatedEvent = {
        'eventName': _eventNameController.text,
        'eventDate': _eventDate!.toIso8601String(),
        'location': _locationController.text,
        'description': _descriptionController.text,
        'shelterID': _selectedShelter!.shelterID,
      };

      try {
        await _eventProvider.updateEvent(widget.event.eventID, updatedEvent);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event updated successfully!')),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update event: ${e.toString()}')),
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
        titleText: 'EDIT EVENT',
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(149, 117, 205, 1)),
              ))
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxHeight: 750, maxWidth: 1300),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              _buildTextField(
                                controller: _eventNameController,
                                label: 'Event Name',
                                icon: Icons.event,
                                validator: (value) => value!.isEmpty
                                    ? 'Event Name cannot be empty'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _locationController,
                                label: 'Location',
                                icon: Icons.location_on,
                                validator: (value) => value!.isEmpty
                                    ? 'Location cannot be empty'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _descriptionController,
                                label: 'Description',
                                icon: Icons.description,
                                maxLines: 4,
                                validator: (value) => value!.isEmpty
                                    ? 'Description cannot be empty'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromRGBO(149, 117, 205, 0.5),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                    'Event Date: ${_eventDate != null ? _eventDate!.toLocal().toString().split(' ')[0] : 'Select Date'}',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(82, 59, 121, 1),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: const Icon(Icons.calendar_today,
                                      color: Color.fromRGBO(149, 117, 205, 1)),
                                  onTap: () => _selectDate(context),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildShelterDropdown(),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(149, 117, 205, 1),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 3,
                                  shadowColor: const Color.fromRGBO(149, 117, 205, 0.4),
                                ),
                                onPressed: _saveChanges,
                                child: const Text('Save Changes', 
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Color.fromRGBO(82, 59, 121, 1)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromRGBO(149, 117, 205, 0.7)),
        prefixIcon: Icon(icon, color: const Color.fromRGBO(149, 117, 205, 1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(149, 117, 205, 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(149, 117, 205, 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(149, 117, 205, 1), width: 1.5),
        ),
        filled: true,
        fillColor: const Color.fromRGBO(249, 247, 252, 1),
      ),
      validator: validator,
    );
  }

  Widget _buildShelterDropdown() {
    return DropdownButtonFormField<Shelter>(
      dropdownColor: const Color.fromRGBO(249, 247, 252, 1),
      style: const TextStyle(color: Color.fromRGBO(82, 59, 121, 1)),
      decoration: InputDecoration(
        labelText: 'Select Shelter',
        labelStyle: const TextStyle(color: Color.fromRGBO(149, 117, 205, 0.7)),
        prefixIcon: const Icon(Icons.pets, color: Color.fromRGBO(149, 117, 205, 1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(149, 117, 205, 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(149, 117, 205, 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(149, 117, 205, 1), width: 1.5),
        ),
        filled: true,
        fillColor: const Color.fromRGBO(249, 247, 252, 1),
      ),
      value: _selectedShelter,
      items: _shelters.map((shelter) {
        return DropdownMenuItem(
          value: shelter,
          child: Text(shelter.name,
              style: const TextStyle(color: Color.fromRGBO(82, 59, 121, 1))),
        );
      }).toList(),
      onChanged: (Shelter? newValue) {
        setState(() {
          _selectedShelter = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a shelter' : null,
      icon: const Icon(Icons.arrow_drop_down, color: Color.fromRGBO(149, 117, 205, 1)),
    );
  }
}
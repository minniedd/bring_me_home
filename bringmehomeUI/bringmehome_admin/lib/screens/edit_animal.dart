import 'package:bringmehome_admin/components/custom_button.dart';
import 'package:bringmehome_admin/components/custom_text_field.dart';
import 'package:bringmehome_admin/components/image_picker.dart';
import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/animal.dart';
import 'package:bringmehome_admin/models/animal_status.dart';
import 'package:bringmehome_admin/models/breed.dart';
import 'package:bringmehome_admin/models/color_model.dart';
import 'package:bringmehome_admin/models/shelter.dart';
import 'package:bringmehome_admin/models/species.dart';
import 'package:bringmehome_admin/models/temperment.dart';
import 'package:bringmehome_admin/services/animal_provider.dart';
import 'package:bringmehome_admin/services/animal_status_provider.dart';
import 'package:bringmehome_admin/services/breed_provider.dart';
import 'package:bringmehome_admin/services/color_provider.dart';
import 'package:bringmehome_admin/services/shelter_provider.dart';
import 'package:bringmehome_admin/services/species_provider.dart';
import 'package:bringmehome_admin/services/temperment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditAnimalDataScreen extends StatefulWidget {
  final Animal animal;
  const EditAnimalDataScreen({super.key, required this.animal});

  @override
  State<EditAnimalDataScreen> createState() => _EditAnimalDataScreenState();
}

class _EditAnimalDataScreenState extends State<EditAnimalDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final AnimalProvider _animalProvider = AnimalProvider();
  final BreedProvider _breedProvider = BreedProvider();
  final AnimalStatusProvider _animalStatusProvider = AnimalStatusProvider();
  final ShelterProvider _shelterProvider = ShelterProvider();
  final ColorProvider _colorProvider = ColorProvider();
  final TempermentProvider _tempermentProvider = TempermentProvider();
  final SpeciesProvider _speciesProvider = SpeciesProvider();

  List<Breed> _breeds = [];
  int? _selectedBreedId;
  bool _isLoadingBreeds = true;

  List<AnimalStatus> _statuses = [];
  int? _selectedStatusId;
  bool _isLoadingStatuses = true;

  List<Shelter> _shelters = [];
  int? _selectedShelterId;
  bool _isLoadingShelters = true;

  List<ColorModel> _colors = [];
  int? _selectedColorId;
  bool _isLoadingColors = true;

  List<Temperment> _temperments = [];
  int? _selectedTempermentId;
  bool _isLoadingTemperments = true;

  List<Species> _species = [];
  int? _selectedSpeciesId;
  bool _isLoadingSpecies = true;

  bool _isSaving = false;
  String? _base64Image;

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _weightController;
  late TextEditingController _aboutController;
  late TextEditingController _dateArrivedController;
  late TextEditingController _healthStatusController;

  DateTime? _selectedDateArrived;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.animal.name ?? '');
    _ageController =
        TextEditingController(text: widget.animal.age?.toString() ?? '');
    _genderController = TextEditingController(text: widget.animal.gender ?? '');
    _weightController =
        TextEditingController(text: widget.animal.weight?.toString() ?? '');
    _aboutController =
        TextEditingController(text: widget.animal.description ?? '');
    _healthStatusController =
        TextEditingController(text: widget.animal.healthStatus ?? '');

    if (widget.animal.dateArrived != null) {
      _selectedDateArrived = widget.animal.dateArrived;
      _dateArrivedController = TextEditingController(
          text: DateFormat('yyyy-MM-dd').format(widget.animal.dateArrived!));
    } else {
      _dateArrivedController = TextEditingController();
    }

    _base64Image = widget.animal.animalImage;
    _selectedBreedId = widget.animal.breedID;
    _selectedStatusId = widget.animal.statusID;
    _selectedShelterId = widget.animal.shelterID;
    _selectedColorId = widget.animal.colorID;
    _selectedTempermentId = widget.animal.tempermentID;
    _selectedSpeciesId = widget.animal.speciesID;
    _loadSpecies();
    _loadBreeds();
    _loadStatus();
    _loadShelters();
    _loadColors();
    _loadTemperments();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _weightController.dispose();
    _aboutController.dispose();
    _dateArrivedController.dispose();
    _healthStatusController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Animal name is required';
    }
    if (value.trim().length > 100) {
      return 'Name must be 100 characters or less';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Please enter a valid number';
    }
    if (age < 0) {
      return 'Age cannot be negative';
    }
    if (age > 50) {
      return 'Please enter a realistic age';
    }
    return null;
  }

  String? _validateGender(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Gender is required';
    }
    if (value.trim().length > 20) {
      return 'Gender must be 20 characters or less';
    }
    final gender = value.trim().toLowerCase();
    if (!['male', 'female', 'm', 'f'].contains(gender)) {
      return 'Please enter Male, Female, M, or F';
    }
    return null;
  }

  String? _validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Weight is required';
    }
    final weight = double.tryParse(value.trim());
    if (weight == null) {
      return 'Please enter a valid number';
    }
    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }
    if (weight > 1000) {
      return 'Please enter a realistic weight';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }

    if (value.length > 1000) {
      return 'Description must be 1000 characters or less';
    }

    return null;
  }

  String? _validateHealthStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Health status is required';
    }
    if (value.length > 500) {
      return 'Health status must be 500 characters or less';
    }
    return null;
  }

  Future<void> _loadSpecies() async {
    setState(() => _isLoadingSpecies = true);
    try {
      _species = await _speciesProvider.getSpecies();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load species: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingSpecies = false);
    }
  }

  Future<void> _loadBreeds() async {
    setState(() => _isLoadingBreeds = true);
    try {
      if (_selectedSpeciesId != null) {
        _breeds = await _breedProvider.getBreedsBySpecies(_selectedSpeciesId!);
      } else {
        _breeds = await _breedProvider.getBreeds();
      }

      if (_selectedBreedId == null &&
          widget.animal.breedName != null &&
          _breeds.isNotEmpty) {
        final initialBreed = _breeds.firstWhere(
          (breed) => breed.breedName == widget.animal.breedName,
          orElse: () => _breeds.first,
        );
        _selectedBreedId = initialBreed.breedID;
      }

      if (_selectedBreedId != null &&
          !_breeds.any((b) => b.breedID == _selectedBreedId)) {
        _selectedBreedId = _breeds.isNotEmpty ? _breeds.first.breedID : null;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load breeds: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingBreeds = false);
    }
  }

  Future<void> _loadStatus() async {
    setState(() => _isLoadingStatuses = true);
    try {
      _statuses = await _animalStatusProvider.getAnimalStatus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load statuses: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingStatuses = false);
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

  Future<void> _loadColors() async {
    setState(() => _isLoadingColors = true);
    try {
      _colors = await _colorProvider.getColors();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load colors: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingColors = false);
    }
  }

  Future<void> _loadTemperments() async {
    setState(() => _isLoadingTemperments = true);
    try {
      _temperments = await _tempermentProvider.getTemperments();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load temperaments: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingTemperments = false);
    }
  }

  Future<void> _selectDateArrived(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateArrived ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateArrived) {
      setState(() {
        _selectedDateArrived = picked;
        _dateArrivedController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
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
      'name': _nameController.text.trim(),
      'age': int.tryParse(_ageController.text.trim()),
      'gender': _genderController.text.trim(),
      'weight': double.tryParse(_weightController.text.trim()),
      'description': _aboutController.text.trim().isEmpty
          ? null
          : _aboutController.text.trim(),
      'healthStatus': _healthStatusController.text.trim().isEmpty
          ? null
          : _healthStatusController.text.trim(),
      'dateArrived': _dateArrivedController.text.isNotEmpty
          ? _dateArrivedController.text
          : null,
      'breedId': _selectedBreedId,
      'statusId': _selectedStatusId,
      'shelterId': _selectedShelterId,
      'colorId': _selectedColorId,
      'temperamentId': _selectedTempermentId,
      'speciesId': _selectedSpeciesId,
      'animalImage': _base64Image,
    };

    updateRequestData.removeWhere(
        (key, value) => value == null || (value is String && value.isEmpty));

    try {
      Animal result = await _animalProvider.updateAnimal(
        widget.animal.animalID!,
        updateRequestData,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Animal "${result.name}" updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update animal: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error updating animal: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _deleteAnimal() async {
    bool confirmDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: Text(
                  'Are you sure you want to delete "${widget.animal.name}"? This action cannot be undone.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmDelete) {
      setState(() {
        _isSaving = true;
      });
      try {
        bool success =
            await _animalProvider.deleteAnimal(widget.animal.animalID ?? 0);

        if (!mounted) return;
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Animal "${widget.animal.name}" deleted successfully!')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Deletion failed. The animal might have related records or was not found.')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting animal: ${e.toString()}')),
        );
        print('Error deleting animal: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  Widget _buildDropdown<T>({
    required String labelText,
    required String hintText,
    required int? selectedValueId,
    required List<T> items,
    required String Function(T item) getItemName,
    required int Function(T item) getItemValue,
    required bool isLoading,
    required ValueChanged<int?> onChanged,
    String? noItemsText,
    FormFieldValidator<int?>? validator,
  }) {
    if (isLoading) {
      return Row(children: [
        Expanded(child: Text('$labelText: Loading...')),
        const SizedBox(width: 10),
        const CircularProgressIndicator(strokeWidth: 2),
      ]);
    }
    if (items.isEmpty && !isLoading) {
      return Text(noItemsText ?? 'No $labelText available.');
    }

    T? currentSelectedItem;
    if (selectedValueId != null && items.isNotEmpty) {
      try {
        currentSelectedItem =
            items.firstWhere((item) => getItemValue(item) == selectedValueId);
      } catch (e) {
        currentSelectedItem = null;
      }
    }

    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 2)),
      ),
      value: currentSelectedItem,
      hint: Text(hintText),
      isExpanded: true,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(getItemName(item)),
        );
      }).toList(),
      onChanged: (T? newValue) {
        onChanged(newValue != null ? getItemValue(newValue) : null);
      },
      validator: (T? value) {
        if (validator != null) {
          return validator(value != null ? getItemValue(value) : null);
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = _isLoadingBreeds ||
        _isLoadingStatuses ||
        _isLoadingShelters ||
        _isLoadingColors ||
        _isLoadingTemperments ||
        _isLoadingSpecies ||
        _isSaving;

    return MasterScreenWidget(
      backButton: true,
      titleText: 'EDIT ANIMAL INFORMATION',
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 750, maxWidth: 1300),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ImagePickerWidget(
                                  initialImageBase64: widget.animal.animalImage,
                                  onImageChanged: (newBase64) {
                                    setState(() {
                                      _base64Image = newBase64;
                                    });
                                  },
                                ),
                                const SizedBox(height: 40),
                                CustomButton(
                                  buttonText: 'DELETE ANIMAL',
                                  onTap: _deleteAnimal,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                    hintText: 'Enter animal name',
                                    controller: _nameController,
                                    labelText: 'Animal Name *',
                                    validator: _validateName,
                                  ),
                                  const SizedBox(height: 15),
                                  _buildDropdown<Species>(
                                    labelText: 'Species *',
                                    hintText: 'Select Species',
                                    selectedValueId: _selectedSpeciesId,
                                    items: _species,
                                    getItemName: (Species species) =>
                                        species.speciesName,
                                    getItemValue: (Species species) =>
                                        species.speciesID,
                                    isLoading: _isLoadingSpecies,
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        _selectedSpeciesId = newValue;
                                        _selectedBreedId = null;
                                      });
                                      if (newValue != null) {
                                        _loadBreeds();
                                      }
                                    },
                                    validator: (value) => value == null
                                        ? 'Please select a species'
                                        : null,
                                  ),
                                  const SizedBox(height: 15),
                                  _buildDropdown<Breed>(
                                    labelText: 'Breed *',
                                    hintText: 'Select Breed',
                                    selectedValueId: _selectedBreedId,
                                    items: _breeds,
                                    getItemName: (Breed breed) =>
                                        breed.breedName,
                                    getItemValue: (Breed breed) =>
                                        breed.breedID,
                                    isLoading: _isLoadingBreeds,
                                    onChanged: (int? newValue) => setState(
                                        () => _selectedBreedId = newValue),
                                    validator: (value) => value == null
                                        ? 'Please select a breed'
                                        : null,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    hintText: 'e.g., 2',
                                    controller: _ageController,
                                    labelText: 'Animal Age *',
                                    keyboardType: TextInputType.number,
                                    validator: _validateAge,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    hintText: 'Male, Female, M, F',
                                    controller: _genderController,
                                    labelText: 'Animal Gender *',
                                    validator: _validateGender,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    hintText: 'e.g., 15.5',
                                    controller: _weightController,
                                    labelText: 'Animal Weight (kg) *',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    validator: _validateWeight,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    controller: _dateArrivedController,
                                    labelText: 'Date Arrived *',
                                    hintText: 'Select arrival date',
                                    readOnly: true,
                                    onTap: () => _selectDateArrived(context),
                                    suffixIcon: Icon(Icons.calendar_today,
                                        color: Theme.of(context).primaryColor),
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? 'Please select arrival date'
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                    hintText: 'e.g., Vaccinated, Healthy',
                                    controller: _healthStatusController,
                                    labelText: 'Health Status *',
                                    validator: _validateHealthStatus,
                                  ),
                                  const SizedBox(height: 15),
                                  _buildDropdown<AnimalStatus>(
                                    labelText: 'Status *',
                                    hintText: 'Select Status',
                                    selectedValueId: _selectedStatusId,
                                    items: _statuses,
                                    getItemName: (AnimalStatus item) =>
                                        item.statusName,
                                    getItemValue: (AnimalStatus item) =>
                                        item.statusID,
                                    isLoading: _isLoadingStatuses,
                                    onChanged: (int? newValue) => setState(
                                        () => _selectedStatusId = newValue),
                                    validator: (value) => value == null
                                        ? 'Please select a status'
                                        : null,
                                  ),
                                  const SizedBox(height: 15),
                                  _buildDropdown<Shelter>(
                                    labelText: 'Shelter *',
                                    hintText: 'Select Shelter',
                                    selectedValueId: _selectedShelterId,
                                    items: _shelters,
                                    getItemName: (Shelter item) => item.name,
                                    getItemValue: (Shelter item) =>
                                        item.shelterID,
                                    isLoading: _isLoadingShelters,
                                    onChanged: (int? newValue) => setState(
                                        () => _selectedShelterId = newValue),
                                    validator: (value) => value == null
                                        ? 'Please select a shelter'
                                        : null,
                                  ),
                                  const SizedBox(height: 15),
                                  _buildDropdown<ColorModel>(
                                    labelText: 'Color *',
                                    hintText: 'Select Color',
                                    selectedValueId: _selectedColorId,
                                    items: _colors,
                                    getItemName: (ColorModel item) =>
                                        item.colorName ?? 'Unknown Color',
                                    getItemValue: (ColorModel item) =>
                                        item.colorID ?? -1,
                                    isLoading: _isLoadingColors,
                                    onChanged: (int? newValue) => setState(
                                        () => _selectedColorId = newValue),
                                    validator: null,
                                  ),
                                  const SizedBox(height: 15),
                                  _buildDropdown<Temperment>(
                                    labelText: 'Temperament *',
                                    hintText: 'Select Temperament',
                                    selectedValueId: _selectedTempermentId,
                                    items: _temperments,
                                    getItemName: (Temperment item) =>
                                        item.name ?? 'Unknown Temperament',
                                    getItemValue: (Temperment item) =>
                                        item.temperamentID ?? -1,
                                    isLoading: _isLoadingTemperments,
                                    onChanged: (int? newValue) => setState(
                                        () => _selectedTempermentId = newValue),
                                    validator: null,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    controller: _aboutController,
                                    labelText:
                                        'Animal Description (max 1000 chars)',
                                    hintText:
                                        'Enter more details about the animal...',
                                    maxLines: 4,
                                    validator: _validateDescription,
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomButton(
                                        buttonText: "SAVE CHANGES",
                                        onTap: _confirmChanges,
                                        color: Colors.green.shade400,
                                      ),
                                      CustomButton(
                                        buttonText: "CANCEL",
                                        onTap: () => Navigator.pop(context),
                                        color: Colors.deepPurple.shade300,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
}

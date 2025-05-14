import 'package:bringmehome_admin/components/custom_button.dart';
import 'package:bringmehome_admin/components/custom_text_field.dart';
import 'package:bringmehome_admin/components/master_screen.dart';
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

class AddAnimalScreen extends StatefulWidget {
  const AddAnimalScreen({super.key});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
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
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _weightController = TextEditingController();
    _aboutController = TextEditingController();
    _dateArrivedController = TextEditingController();
    _healthStatusController = TextEditingController();
    _loadBreeds();
    _loadStatus();
    _loadShelters();
    _loadColors();
    _loadTemperments();
    _loadSpecies();
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

  Future<void> _saveAnimal() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please correct the errors in the form.'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final Map<String, dynamic> animalData = {
      'name': _nameController.text,
      'age': _ageController.text,
      'gender': _genderController.text,
      'weight': _weightController.text,
      'description': _aboutController.text,
      'healthStatus': _healthStatusController.text,
      'dateArrived': _dateArrivedController.text.isNotEmpty
          ? _dateArrivedController.text
          : null,
      'breedId': _selectedBreedId,
      'statusId': _selectedStatusId,
      'shelterId': _selectedShelterId,
      'colorId': _selectedColorId,
      'temperamentId': _selectedTempermentId,
    };

    animalData.removeWhere(
        (key, value) => value == null || (value is String && value.isEmpty));

    try {
      await _animalProvider.addAnimal(animalData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Animal saved successfully!'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to save animal: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
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
    return MasterScreenWidget(
      titleText: 'ADD ANIMAL INFORMATION',
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 750, maxWidth: 1300),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: _isLoadingBreeds ||
                  _isLoadingStatuses ||
                  _isLoadingShelters ||
                  _isLoadingColors ||
                  _isLoadingTemperments ||
                  _isSaving
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    'https://picsum.photos/250?image=9', // add later
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                                height: 200,
                                                width: 200,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                    Icons.broken_image,
                                                    size: 50)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  buttonText: 'UPLOAD IMAGE',
                                  onTap: () {
                                    // implement image picking
                                  },
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? 'Please enter animal name'
                                            : null,
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
                                      hintText: 'e.g., 2 years',
                                      controller: _ageController,
                                      labelText: 'Animal Age'),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                      hintText: 'Male, Female',
                                      controller: _genderController,
                                      labelText: 'Animal Gender'),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                      hintText: 'e.g., 15.5 kg',
                                      controller: _weightController,
                                      labelText: 'Animal Weight (kg)',
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true)),
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
                                      hintText: 'e.g., Vaccinated',
                                      controller: _healthStatusController,
                                      labelText: 'Health Status'),
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
                                    validator: (value) => value == null
                                        ? 'Please select a color'
                                        : null,
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
                                    validator: (value) => value == null
                                        ? 'Please select a temperament'
                                        : null,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    controller: _aboutController,
                                    labelText: 'Animal Description',
                                    hintText:
                                        'Enter more details about the animal...',
                                    maxLines: 4,
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomButton(
                                        buttonText: "SAVE ANIMAL",
                                        onTap: _saveAnimal,
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

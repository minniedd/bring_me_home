import 'package:bringmehome_admin/components/custom_button.dart';
import 'package:bringmehome_admin/components/custom_text_field.dart';
import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/animal.dart';
import 'package:bringmehome_admin/models/breed.dart';
import 'package:bringmehome_admin/services/animal_provider.dart';
import 'package:bringmehome_admin/services/breed_provider.dart';
import 'package:flutter/material.dart';

class EditAnimalDataScreen extends StatefulWidget {
  final Animal animal;
  const EditAnimalDataScreen({super.key, required this.animal});

  @override
  State<EditAnimalDataScreen> createState() => _EditAnimalDataScreenState();
}

class _EditAnimalDataScreenState extends State<EditAnimalDataScreen> {
  final AnimalProvider _animalProvider = AnimalProvider();
  final BreedProvider _breedProvider = BreedProvider();
  List<Breed> _breeds = [];
  int? _selectedBreedId;
  bool _isLoadingBreeds = true;
  bool _isSaving = false; 

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _weightController;
  late TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.animal.name ?? '');
    _ageController = TextEditingController(text: widget.animal.age?.toString() ?? '');
    _genderController = TextEditingController(text: widget.animal.gender ?? '');
    _weightController = TextEditingController(text: widget.animal.weight?.toString() ?? '');
    _aboutController = TextEditingController(text: widget.animal.description ?? '');
    _selectedBreedId = widget.animal.breedID;
    _loadBreeds();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _weightController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _loadBreeds() async {
    setState(() {
      _isLoadingBreeds = true;
    });
    try {
      _breeds = await _breedProvider.getBreeds();

      if (_selectedBreedId == null && widget.animal.breedName != null && _breeds.isNotEmpty) {
        final initialBreed = _breeds.firstWhere(
          (breed) => breed.breedName == widget.animal.breedName,
          orElse: () => _breeds.first,
        );
        _selectedBreedId = initialBreed.breedID;
      }
      if (_selectedBreedId != null && !_breeds.any((b) => b.breedID == _selectedBreedId)) {
         _selectedBreedId = _breeds.isNotEmpty ? _breeds.first.breedID : null;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load breeds: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBreeds = false;
        });
      }
    }
  }

  void _confirmChanges() async {
    if (_isSaving) return; 

    setState(() {
      _isSaving = true;
    });

    String updatedName = _nameController.text;
    int? updatedAge = int.tryParse(_ageController.text);
    String updatedGender = _genderController.text;
    double? updatedWeight = double.tryParse(_weightController.text);
    String updatedAbout = _aboutController.text;

    if (updatedName.isEmpty || _selectedBreedId == null || updatedGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    Map<String, dynamic> updateRequestData = {
      'name': updatedName,
      'breedID': _selectedBreedId,
      'age': updatedAge,
      'gender': updatedGender,
      'weight': updatedWeight,
      'description': updatedAbout,
      'dateArrived': widget.animal.dateArrived?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'statusID': widget.animal.statusID ?? 1,
      'healthStatus': widget.animal.healthStatus ?? "Unknown",
      'shelterID': widget.animal.shelterID, 
    };

    try {
      Animal result = await _animalProvider.updateAnimal(
        widget.animal.animalID!,
        updateRequestData,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Animal "${result.name}" updated successfully!')),
      );

      Navigator.pop(context, result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update animal: ${e.toString()}')),
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
          content: Text('Are you sure you want to delete "${widget.animal.name}"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete',style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false;

    if (confirmDelete) {
      setState(() {
        _isSaving = true;
      });
      try {
        bool success = await _animalProvider.deleteAnimal(widget.animal.animalID ?? 0);

        if (!mounted) return;
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Animal "${widget.animal.name}" deleted successfully!')),
          );
          Navigator.pop(context, true); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deletion failed. The animal might have related records or was not found.')),
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: 'EDIT ANIMAL INFORMATION',
      child: Center(
        child: Container(
          height: 500,
          width: 1300,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: _isLoadingBreeds || _isSaving
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              'https://picsum.photos/250?image=9', // use animal image later
                              height: 300,
                              width: 300,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 300,
                                  width: 300,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.broken_image, color: Colors.red, size: 50),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: CustomButton(
                              buttonText: 'DELETE',
                              onTap: _deleteAnimal,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(hintText: 'Animal Name', controller: _nameController,labelText: 'Animal Name',),
                            const SizedBox(height: 20),
                            // breed dropdown
                            _breeds.isEmpty && !_isLoadingBreeds
                                ? Text("No breeds available or failed to load.")
                                : DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      labelText: 'Animal Breed',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.secondary, width: 2),
                                      ),
                                    ),
                                    value: _selectedBreedId,
                                    hint: Text('Select Breed'),
                                    isExpanded: true,
                                    items: _breeds.map((Breed breed) {
                                      return DropdownMenuItem<int>(
                                        value: breed.breedID, 
                                        child: Text(breed.breedName),
                                      );
                                    }).toList(),
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        _selectedBreedId = newValue;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select a breed';
                                      }
                                      return null;
                                    },
                                  ),
                            const SizedBox(height: 20),
                            CustomTextField(hintText: 'Animal Age', controller: _ageController,labelText: 'Animal Age',),
                            const SizedBox(height: 20),
                            CustomTextField(hintText: 'Animal Gender', controller: _genderController,labelText: 'Animal Gender'),
                            const SizedBox(height: 20),
                            CustomTextField(hintText: 'Animal Weight (kg)', controller: _weightController, labelText: 'Animal Weight',),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _aboutController,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  hintText: 'Description',
                                  labelText: 'Animal Description',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              keyboardType: TextInputType.multiline,
                              maxLines: 10,
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  buttonText: "CONFIRM",
                                  onTap: _confirmChanges,
                                  color: Colors.green.shade400,
                                ),
                                const SizedBox(width: 20),
                                CustomButton(
                                  buttonText: "CANCEL",
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.deepPurple.shade300,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
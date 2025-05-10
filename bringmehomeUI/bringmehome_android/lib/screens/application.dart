import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_app/components/custom_check_box.dart';
import 'package:learning_app/components/custom_text_field.dart';
import 'package:learning_app/models/user.dart';
import 'package:learning_app/providers/adoption_application_provider.dart';
import 'package:learning_app/providers/user_provider.dart';
import 'package:learning_app/screens/application_congrats_screen.dart';
import 'package:provider/provider.dart';

class ApplicationScreen extends StatefulWidget {
  final int animalId;

  const ApplicationScreen({super.key, required this.animalId});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  late AdoptionApplicationProvider _adoptionApplicationProvider;
  late UserProvider _userProvider;
  User? _loggedInUser;
  bool _isLoadingUser = true;
  bool _isSubmitting = false;

  final TextEditingController _livingSituationController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isAnimalAllowed = false;
  int? _selectedReasonId;

  final Map<String, int> _reasonMapping = {
    'Companion for a child': 1,
    'Companion for another pet': 2,
    'Companion for yourself': 3,
    'Service animal': 4,
    'Safety': 5,
    'Pet': 6,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _adoptionApplicationProvider =
          context.read<AdoptionApplicationProvider>();
      _userProvider = context.read<UserProvider>();
      _loadUserData();
    });
  }

  @override
  void dispose() {
    _livingSituationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      await _userProvider.loadCurrentUser();
      _loggedInUser = _userProvider.currentUser;

      if (_loggedInUser == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load user data. Cannot apply.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error while loading user data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUser = false;
        });
      }
    }
  }

  void _onReasonCheckboxChanged(String title, bool isChecked) {
    final reasonId = _reasonMapping[title];
    if (reasonId != null) {
      setState(() {
        _selectedReasonId = isChecked ? reasonId : null;
      });
    }
  }

  void _onAnimalAllowedChanged(bool? value) {
    if (value != null) {
      setState(() {
        _isAnimalAllowed = value;
      });
    }
  }

  Future<void> _submitApplication() async {
    if (_loggedInUser == null || _loggedInUser!.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'User data or ID not available. Cannot submit application. Please try logging in again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_livingSituationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your living situation.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final livingSituation = _livingSituationController.text.trim();
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

          final String isAnimalAllowedString = _isAnimalAllowed ? 'Yes' : 'No';


      await _adoptionApplicationProvider.createApplication(
        userId: _loggedInUser!.id!,
        animalId: widget.animalId,
        livingSituation: livingSituation,
        isAnimalAllowed: isAnimalAllowedString,
        reasonId: _selectedReasonId,
        notes: notes,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ApplicationCongratsScreen(),
          ),
        );
      }
    } on DioException catch (e) {
      String userMessage = 'Error while sending application.';
      if (e.response?.data is Map<String, dynamic> &&
          e.response!.data.containsKey('message')) {
        userMessage = e.response!.data['message'] as String;
      } else if (e.message != null) {
        userMessage = e.message!;
      } else {
        userMessage = "Network Error!";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while sending application: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: Text(
            "APPLICATION",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_loggedInUser == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: Text(
            "APPLICATION",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: Center(
          child: Text(
            'Could not load user data. Please try again later.',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          "APPLICATION",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: StepTwo(
        livingSituationController: _livingSituationController,
        notesController: _notesController,
        isAnimalAllowed: _isAnimalAllowed,
        onAnimalAllowedChanged: _onAnimalAllowedChanged,
        selectedReasonId: _selectedReasonId,
        reasonMapping: _reasonMapping,
        onReasonCheckboxChanged: _onReasonCheckboxChanged,
        isSubmitting: _isSubmitting,
        onBack: () => Navigator.of(context).pop(),
        onSubmit: _submitApplication,
      ),
    );
  }
}

class StepTwo extends StatelessWidget {
  final TextEditingController livingSituationController;
  final TextEditingController notesController;
  final bool isAnimalAllowed;
  final ValueChanged<bool?> onAnimalAllowedChanged;
  final int? selectedReasonId;
  final Map<String, int> reasonMapping;
  final Function(String title, bool isChecked) onReasonCheckboxChanged;
  final bool isSubmitting;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const StepTwo({
    required this.livingSituationController,
    required this.notesController,
    required this.isAnimalAllowed,
    required this.onAnimalAllowedChanged,
    required this.selectedReasonId,
    required this.reasonMapping,
    required this.onReasonCheckboxChanged,
    required this.isSubmitting,
    required this.onBack,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
                controller: livingSituationController,
                hintText: 'What type of housing do you live in?',
                obscureText: false),
            const SizedBox(height: 10),
            Text(
              'Are pets allowed in your home?',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('Yes',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    value: true,
                    groupValue: isAnimalAllowed,
                    onChanged: onAnimalAllowedChanged,
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('No',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    value: false,
                    groupValue: isAnimalAllowed,
                    onChanged: onAnimalAllowedChanged,
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Why do you want to adopt? (Pick one)',
                style: GoogleFonts.poppins(color: Colors.white)),
            const SizedBox(height: 10),
            ...reasonMapping.keys.map((title) {
              final reasonId = reasonMapping[title]!;
              final isSelected = selectedReasonId == reasonId;
              return CustomCheckBox(
                titleText: title,
                value: isSelected,
                onChanged: (isChecked) {
                  onReasonCheckboxChanged(title, isChecked ?? false);
                },
              );
            }),
            const SizedBox(height: 10),
            CustomTextField(
                controller: notesController,
                hintText: 'Others (Notes)',
                obscureText: false,
                maxLines: 3),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: onBack, child: const Icon(Icons.arrow_back)),
                ElevatedButton(
                  onPressed: isSubmitting ? null : onSubmit,
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit"),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

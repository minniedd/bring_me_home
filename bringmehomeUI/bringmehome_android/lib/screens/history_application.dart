import 'package:flutter/material.dart';
import 'package:learning_app/components/animal_window.dart';
import 'package:learning_app/models/adoption_application.dart';
import 'package:learning_app/providers/adoption_application_provider.dart';
import 'package:learning_app/screens/animal_screen.dart';
import 'package:learning_app/widgets/master_screen.dart';

class HistoryApplicationScreen extends StatefulWidget {
  const HistoryApplicationScreen({super.key});

  @override
  State<HistoryApplicationScreen> createState() =>
      _HistoryApplicationScreenState();
}

class _HistoryApplicationScreenState extends State<HistoryApplicationScreen> {
  final AdoptionApplicationProvider _adoptionApplicationProvider =
      AdoptionApplicationProvider();
  List<AdoptionApplication> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    try {
      final applications = await _adoptionApplicationProvider.getHistory();
      setState(() {
        _applications = applications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load applications'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      settingsIcon: true,
      titleText: "HISTORY",
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _applications.isEmpty
                ? const Center(child: Text('No applications yet'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _applications.length,
                    itemBuilder: (context, index) {
                      final animal = _applications[index];
                      return Column(
                        children: [
                          AnimalWindow(
                            animalName: animal.animal?.name ?? 'Unknown',
                            animalAge:
                                animal.animal?.age?.toString() ?? 'Unknown',
                            shelterCity: '${animal.animal?.shelterName}',
                            isFavorite: true,
                            onTap: () {
                              if (animal.animal != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AnimalScreen(animal: animal.animal!),
                                  ),
                                );
                              }
                            },
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(176, 139, 215, 1),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.only(
                                left: 100, right: 100, top: 10, bottom: 10),
                            child: Text(
                              "${animal.statusName}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}

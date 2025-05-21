import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/application.dart';
import 'package:bringmehome_admin/models/staff.dart';
import 'package:bringmehome_admin/services/animal_applications_provider.dart';
import 'package:bringmehome_admin/services/staff_provider.dart';
import 'package:flutter/material.dart';

class ApplicationDetailsScreen extends StatefulWidget {
  final AnimalApplication animalApplication;
  const ApplicationDetailsScreen({super.key, required this.animalApplication});

  @override
  State<ApplicationDetailsScreen> createState() =>
      _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState extends State<ApplicationDetailsScreen> {
  final TextEditingController _notesController = TextEditingController();
  List<Staff> _staffList = [];
  Staff? _selectedStaff;
  bool _isLoading = false;
  final AnimalApplicationsProvider _applicationsProvider =
      AnimalApplicationsProvider();
  final StaffProvider _staffProvider = StaffProvider();

  @override
  void initState() {
    super.initState();
    _loadStaffMembers();
  }

  Future<void> _loadStaffMembers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final staffList = await _staffProvider.getStaff();
      setState(() {
        _staffList = staffList;
        if (staffList.isNotEmpty) {
          _selectedStaff = staffList.first;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load staff members: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _approveApplication() async {
    if (_selectedStaff == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a staff member for review')),
      );
      return;
    }
    if (_notesController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter review notes before approving')),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedApplication = AnimalApplication(
        applicationID: widget.animalApplication.applicationID,
        userID: widget.animalApplication.userID,
        animalID: widget.animalApplication.animalID,
        reviewedBy: _selectedStaff,
        notes: _notesController.text.trim(),
        statusID: widget.animalApplication.statusID,
      );

      await _applicationsProvider.approve(updatedApplication);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application approved successfully')),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve application: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _rejectApplication() async {
    if (_selectedStaff == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a staff member for review')),
      );
      return;
    }
    if (_notesController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please enter rejection reason in notes before rejecting')),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedApplication = AnimalApplication(
        applicationID: widget.animalApplication.applicationID,
        userID: widget.animalApplication.userID,
        animalID: widget.animalApplication.animalID,
        reviewedBy: _selectedStaff,
        notes: _notesController.text.trim(),
        statusID: widget.animalApplication.statusID,
      );

      await _applicationsProvider.reject(updatedApplication);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application rejected successfully')),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject application: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final application = widget.animalApplication;

    return MasterScreenWidget(
      backButton: true,
      titleText:
          "Application Details for application #${application.applicationID}"
              .toUpperCase(),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Application Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(height: 20, thickness: 1),
                  _buildDetailRow(
                      'ApplicationID:', application.applicationID.toString()),
                  _buildDetailRow(
                      'Status:', application.statusName ?? 'Unknown'),
                  _buildDetailRow(
                    'Application Date:',
                    application.applicationDate != null
                        ? application.applicationDate!
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                        : 'Unknown',
                  ),
                  _buildDetailRow('Living situation:',
                      application.livingSituation ?? 'Unknown'),
                  _buildDetailRow('Is Animal Allowed:',
                      application.isAnimalAllowed ?? 'Unknown'),
                  _buildDetailRow(
                      'Reason:', application.reasonName ?? 'Unknown'),
                  const SizedBox(height: 30),
                  Text(
                    'Animal Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(height: 20, thickness: 1),
                  _buildDetailRow(
                      'Animal Name:', application.animal?.name ?? 'Unknown'),
                  _buildDetailRow('Animal Temperment:',
                      application.animal?.tempermentName ?? 'Unknown'),
                  _buildDetailRow('Animal Weight:',
                      application.animal?.weight.toString() ?? 'Unknown'),
                  _buildDetailRow('Animal Age:',
                      application.animal?.age.toString() ?? 'Unknown'),
                  _buildDetailRow('Animal Species:',
                      application.animal?.speciesName ?? 'Unknown'),
                  _buildDetailRow('Animal Breed:',
                      application.animal?.breedName ?? 'Unknown'),
                  _buildDetailRow('Animal Gender:',
                      application.animal?.gender ?? 'Unknown'),
                  _buildDetailRow('Animal Shelter:',
                      application.animal?.shelterName ?? 'Unknown'),
                  const SizedBox(height: 30),
                  Text(
                    'Applicant Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(height: 20, thickness: 1),
                  _buildDetailRow(
                      'Full name:', application.userFullName ?? 'Unknown'),
                  _buildDetailRow(
                      'Email:', application.user?.email ?? 'Unknown'),
                  _buildDetailRow(
                      'Address:', application.user?.address ?? 'Unknown'),
                  _buildDetailRow(
                      'City:', application.user!.city ?? 'Unknown'),
                  _buildDetailRow('Telephone number:',
                      application.user?.phoneNumber ?? 'Unknown'),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text(
                            'Reviewed By:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : DropdownButtonFormField<Staff>(
                                  value: _selectedStaff,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  items: _staffList.map((Staff staff) {
                                    return DropdownMenuItem<Staff>(
                                      value: staff,
                                      child: Text(
                                          '${staff.user?.firstName} ${staff.user?.lastName}'),
                                    );
                                  }).toList(),
                                  onChanged: (Staff? newValue) {
                                    setState(() {
                                      _selectedStaff = newValue;
                                    });
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notes:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _notesController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter notes about this application...',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _isLoading ? null : _rejectApplication,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Reject Application'),
                      ),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _approveApplication,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Accept For Visit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

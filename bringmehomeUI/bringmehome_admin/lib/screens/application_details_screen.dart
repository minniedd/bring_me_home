import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/application.dart';
import 'package:flutter/material.dart';

class ApplicationDetailsScreen extends StatefulWidget {
  final AnimalApplication animalApplication;
  const ApplicationDetailsScreen({super.key, required this.animalApplication});

  @override
  State<ApplicationDetailsScreen> createState() =>
      _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState extends State<ApplicationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final application = widget.animalApplication;

    return MasterScreenWidget(
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
                  _buildDetailRow('Status:', application.statusName ?? 'N/A'),
                  _buildDetailRow(
                    'Application Date:',
                    application.applicationDate != null
                        ? application.applicationDate!
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                        : 'N/A',
                  ),
                  _buildDetailRow('Living situation:',
                      application.livingSituation ?? 'N/A'),
                  _buildDetailRow('Is Animal Allowed:',
                      application.isAnimalAllowed ?? 'N/A'),
                  _buildDetailRow('Reason:', application.reasonName ?? 'N/A'),
                  const SizedBox(height: 30),
                  Text(
                    'Animal Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(height: 20, thickness: 1),
                  _buildDetailRow(
                      'Animal Name:', application.animal?.name ?? 'N/A'),
                  _buildDetailRow('Animal Temperment:',
                      application.animal?.tempermentName ?? 'N/A'),
                  _buildDetailRow('Animal Weight:',
                      application.animal?.weight.toString() ?? 'N/A'),
                  _buildDetailRow('Animal Age:',
                      application.animal?.age.toString() ?? 'N/A'),
                  _buildDetailRow('Animal Species:',
                      application.animal?.speciesName ?? 'N/A'),
                  _buildDetailRow(
                      'Animal Breed:', application.animal?.breedName ?? 'N/A'),
                  _buildDetailRow(
                      'Animal Gender:', application.animal?.gender ?? 'N/A'),
                  _buildDetailRow('Animal Shelter:',
                      application.animal?.shelterName ?? 'N/A'),
                  const SizedBox(height: 30),
                  Text(
                    'Applicant Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(height: 20, thickness: 1),
                  _buildDetailRow(
                      'Full name:', application.userFullName ?? 'N/A'),
                  _buildDetailRow('Email:', application.user?.email ?? 'N/A'),
                  _buildDetailRow(
                      'Address:', application.user?.address ?? 'N/A'),
                  _buildDetailRow('City:', application.user?.city ?? 'N/A'),
                  _buildDetailRow('Telephone number:',
                      application.user?.phoneNumber ?? 'N/A'),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // implement reject
                          print('Reject button pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Reject Application'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // implement accept for visit
                          print('Accept for Visit button pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Accept For Visit'),
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

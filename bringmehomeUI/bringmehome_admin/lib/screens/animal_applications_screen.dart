import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/animal.dart';
import 'package:bringmehome_admin/models/application.dart';
import 'package:bringmehome_admin/screens/application_details_screen.dart';
import 'package:bringmehome_admin/services/animal_applications_provider.dart';
import 'package:flutter/material.dart';

class AnimalApplicationsScreen extends StatefulWidget {
  final Animal animal;
  const AnimalApplicationsScreen({super.key, required this.animal});

  @override
  State<AnimalApplicationsScreen> createState() =>
      _AnimalApplicationsScreenState();
}

class _AnimalApplicationsScreenState extends State<AnimalApplicationsScreen> {
  final AnimalApplicationsProvider _animalApplicationsProvider =
      AnimalApplicationsProvider();
  late Future<List<AnimalApplication>> _applicationsFuture;

  @override
  void initState() {
    super.initState();
    _applicationsFuture = _fetchApplications();
  }

  void _refreshApplications() {
    setState(() {
      _applicationsFuture = _fetchApplications();
    });
  }

  Future<List<AnimalApplication>> _fetchApplications() async {
    if (widget.animal.animalID != null) {
      try {
        return await _animalApplicationsProvider
            .getApplicationByAnimal(widget.animal.animalID!);
      } catch (e) {
        throw Exception('Failed to fetch applications: $e');
      }
    } else {
      return Future.error("Animal ID is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText:
          'APPLICATIONS FOR ${widget.animal.name?.toUpperCase() ?? 'UNKNOWN ANIMAL'}',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<AnimalApplication>>(
                future: _applicationsFuture,
                builder: _buildApplicationList,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationList(
      BuildContext context, AsyncSnapshot<List<AnimalApplication>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(
        child: Text('Error while fetching: ${snapshot.error}'),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child: Text('No applications for this animal!.'),
      );
    } else {
      final applications = snapshot.data!;
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final application = applications[index];
          return _buildApplicationTile(application);
        },
      );
    }
  }

  Widget _buildApplicationTile(AnimalApplication application) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      child: ListTile(
        leading: const Icon(
          Icons.star,
          color: Color.fromRGBO(149, 117, 205, 1),
        ),
        title: Text('Applicant: ${application.userFullName ?? 'Unknown'}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${application.statusName ?? 'Unknown'}'),
            Text(
                'Application Date: ${application.applicationDate != null ? application.applicationDate!.toLocal().toString().split(' ')[0] : 'Unknown'}'),
          ],
        ),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApplicationDetailsScreen(animalApplication: application),
            ),
          );
          if (result == true) {
            _refreshApplications();
          }
        },
      ),
    );
  }
}

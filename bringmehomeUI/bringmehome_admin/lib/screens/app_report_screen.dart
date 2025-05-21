import 'dart:io';
import 'dart:typed_data';

import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/components/report_window.dart';
import 'package:bringmehome_admin/models/app_report.dart';
import 'package:bringmehome_admin/models/app_report_request.dart';
import 'package:bringmehome_admin/services/app_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class AnimalReportScreen extends StatefulWidget {
  const AnimalReportScreen({super.key});

  @override
  State<AnimalReportScreen> createState() => _AnimalReportScreenState();
}

class _AnimalReportScreenState extends State<AnimalReportScreen> {
  late Future<AppReport> _reportFuture;
  late AppReportProvider _appReportProvider;

  @override
  void initState() {
    super.initState();
    _appReportProvider = AppReportProvider();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    setState(() {
      _reportFuture = _appReportProvider.getReportData();
    });
  }

  Future<void> downloadAndSaveReport() async {
    final request = AppReportRequest();

    try {
      final Uint8List pdfBytes = await _appReportProvider.getReportPdf(request);

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Report.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);
      OpenFilex.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading report: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      backButton: true,
      titleText: 'App Report'.toUpperCase(),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: FutureBuilder<AppReport>(
                  future: _reportFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data available'));
                    } else {
                      final report = snapshot.data!;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Bring Me Home Report'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 24),
                          ReportWindowWidget(
                            reportTitle: 'Total Animals',
                            reportValue: report.totalAnimals.toString(),
                          ),
                          const SizedBox(height: 12),
                          ReportWindowWidget(
                            reportTitle: 'Adopted Animals',
                            reportValue: report.totalAdoptions.toString(),
                          ),
                          const SizedBox(height: 12),
                          ReportWindowWidget(
                            reportTitle: 'Available Active Adoptions',
                            reportValue: report.totalActiveAdoptions.toString(),
                          ),
                          const SizedBox(height: 24),
                          KeyValueListWidget(
                            title: 'Total Animals by Species',
                            data: report.totalAnimalsBySpecies,
                          ),
                          ElevatedButton(
                            onPressed: downloadAndSaveReport,
                            child: const Text('Download Report'),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

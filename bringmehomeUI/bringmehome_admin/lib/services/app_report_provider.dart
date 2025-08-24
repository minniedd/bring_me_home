import 'dart:convert';

import 'package:bringmehome_admin/models/app_report.dart';
import 'package:bringmehome_admin/models/app_report_request.dart';
import 'package:bringmehome_admin/services/base_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AppReportProvider extends BaseProvider<AppReport> {
  AppReportProvider() : super("api/AppReport");

  @override
  AppReport fromJson(data) {
    return AppReport.fromJson(data);
  }

  Future<AppReport> getReportData() async {
    final uri = Uri.parse("${BaseProvider.baseUrl}$endpoint");

    try {
      final response = await http.get(
        uri,
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        return fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to load report: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error in getReportData: $e');
      rethrow;
    }
  }

  Future<Uint8List> getReportPdf(AppReportRequest request) async {
    final uri = Uri.parse("${BaseProvider.baseUrl}$endpoint/GetReportPdf");

    try {
      final response = await http.post(
        uri,
        headers: await createHeaders(),
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type']?.toLowerCase();
        if (contentType == 'application/pdf') {
          return response.bodyBytes;
        }
        throw Exception('Expected PDF but received content type: $contentType');
      }

      String errorMessage = 'Failed to load PDF (${response.statusCode})';
      if (response.body.isNotEmpty) {
        try {
          final errorData = jsonDecode(response.body);
          errorMessage += errorData is Map
              ? ': ${errorData['message'] ?? errorData['title'] ?? errorData.toString()}'
              : ': ${response.body}';
        } catch (_) {
          errorMessage += ': ${response.body}';
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Error in getReportPdf: $e');
      rethrow;
    }
  }
}
import 'package:bringmehome_admin/models/search_result.dart';
import 'package:bringmehome_admin/services/base_provider.dart';
import 'package:bringmehome_admin/models/application_status.dart';

class ApplicationStatusProvider extends BaseProvider<ApplicationStatus> {
  ApplicationStatusProvider() : super("api/ApplicationStatus");

  @override
  ApplicationStatus fromJson(data) {
    return ApplicationStatus.fromJson(data);
  }

  Future<List<ApplicationStatus>> getApplicationStatus() async {
    try {
      print('Fetching application statuses...');
      final SearchResult<ApplicationStatus> result = await super.get();

      final List<ApplicationStatus> statuses = result.result;

      print('Fetched ${statuses.length} application statuses');
      return statuses;
    } catch (e) {
      print('Error fetching statuses: $e');
      rethrow;
    }
  }
}

import 'package:bringmehome_admin/models/staff.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

class StaffProvider extends BaseProvider<Staff> {
  StaffProvider() : super("api/Staff");

  @override
  Staff fromJson(data) {
    return Staff.fromJson(data);
  }

  Future<List<Staff>> getStaff() async {
    try {
      final List<Staff> staff = await super.getAll(endpointOverride: "all");

      return staff;
    } catch (e) {
      print('Error fetching staff using getList: $e');
      rethrow;
    }
  }
}
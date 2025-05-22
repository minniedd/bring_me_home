import 'package:learning_app/models/canton.dart';
import 'package:learning_app/providers/base_provider.dart';

class CantonProvider extends BaseProvider<Canton> {
  CantonProvider() : super("api/Canton");

  @override
  Canton fromJson(data) {
    return Canton.fromJson(data);
  }

  Future<List<Canton>> getCantons() async {
    try {
      final List<Canton> cantons = await super.getAll(endpointOverride: "all");

      return cantons;
    } catch (e) {
      rethrow;
    }
  }
}
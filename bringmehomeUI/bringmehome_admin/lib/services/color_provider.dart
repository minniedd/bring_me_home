import 'package:bringmehome_admin/models/color_model.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

class ColorProvider extends BaseProvider<ColorModel> {
  ColorProvider() : super("api/Color");

  @override
  ColorModel fromJson(data) {
    return ColorModel.fromJson(data);
  }

  Future<List<ColorModel>> getColors() async {
    try {
      final List<ColorModel> colors = await super.getAll(endpointOverride: "all");

      return colors;
    } catch (e) {
      print('Error fetching colors using getList: $e');
      rethrow;
    }
  }
}

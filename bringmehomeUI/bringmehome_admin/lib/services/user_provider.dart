import 'package:bringmehome_admin/models/user.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("api/User");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }
}
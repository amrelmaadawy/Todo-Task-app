import 'package:paymob/testApi/core/user_name.dart';

class User {
  final String gender;
  final String email;
  final String phone;
  final Name name;
  User(
      {required this.gender,
      required this.email,
      required this.phone,
      required this.name});
  String get fullName {
    return '${name.title} ${name.first} ${name.last}';
  }
}

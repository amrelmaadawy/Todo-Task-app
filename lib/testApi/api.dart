import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:paymob/testApi/core/module.dart';
import 'package:paymob/testApi/core/user_name.dart';
import 'package:paymob/testApi/home_screen.dart';

class UserApi {
  static Future<List<User>> fetchUsers() async {
    const url = 'http://randomuser.me/api/?results=200';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final result = json['results'] as List<dynamic>;
    final transform = result.map((e) {
      final name = Name(
          first: e['name']['first'],
          last: e['name']['last'],
          title: e['name']['title']);
      return User(
          email: e['email'],
          phone: e['phone'],
          gender: e['gender'],
          name: name);
    }).toList();
    users = transform;
    if (kDebugMode) {
      print('users fetch successfully');
    }
    return transform;
  }
}

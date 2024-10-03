import 'package:flutter/material.dart';
import 'package:paymob/testApi/api.dart';
import 'package:paymob/testApi/core/module.dart';

List<User> users = [];

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final user = users[index];
          final email = user.email;
          final name = user.fullName;
          return ListTile(
            title: Text(name),
            subtitle: Text(email),
          );
        },
        itemCount: users.length,
      ),
    );
  }

  Future<void> fetchUsers() async {
    final response = await UserApi.fetchUsers();
    setState(() {
      users = response;
    });
  }
}

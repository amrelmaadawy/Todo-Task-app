import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paymob/util/snakebar.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, this.todo});
  final Map? todo;
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool isEdit = false;

  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (widget.todo != null) {
      isEdit = true;
      final title = todo!['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 15,
        title: Text(
          isEdit ? 'Edit Task' : 'Add Task',
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(
                'Title',
                style: TextStyle(fontSize: 18),
              )),
              controller: titleController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(
                'Description',
                style: TextStyle(fontSize: 18),
              )),
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 7,
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  isEdit ? updateData() : submitData();
                },
                child: Text(
                  isEdit ? 'Update' : 'Submit',
                  style: const TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> updateData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final todo = widget.todo;
    final id = todo?['_id'];
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      titleController.text = '';
      descriptionController.text = '';

      Snakebar.snakeBar('updated successful', Colors.green, context);
    } else {
      Snakebar.snakeBar('fialed to update', Colors.red, context);
    }
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      if (kDebugMode) {
        print('created successful');
      }
      Snakebar.snakeBar('created successful', Colors.green, context);
    } else {
      if (kDebugMode) {
        print('fialed to create');
      }
      Snakebar.snakeBar('fialed to create', Colors.red, context);
    }
  }
}

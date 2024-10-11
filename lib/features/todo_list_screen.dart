import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paymob/util/snakebar.dart';
import 'package:paymob/screens/add_task_screen.dart';
import 'package:http/http.dart' as http;

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    fethcData();
  }

  bool refreshed = false;
  List items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 15,
        title: const Center(
          child: Text(
            'Todo List',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Visibility(
        visible: refreshed,
        replacement: const Center(child: RefreshProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: () => fethcData(),
          child: ListView.builder(
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    trailing: PopupMenuButton(onSelected: (value) {
                      final id = item['_id'];
                      if (value == 'delet') {
                        deletData(id);
                      }
                      if (value == 'edit') {
                        navigatoToEditPage(item);
                      }
                    }, itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'delet',
                          child: Text('Delet'),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                      ];
                    }),
                  ),
                ),
              );
            },
            itemCount: items.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatoToAddPage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> fethcData() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    final json = jsonDecode(response.body) as Map;
    final result = json['items'] as List;
    setState(() {
      items = result;
      refreshed = true;
    });
  }

  Future<void> deletData(id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    final filtered = items
        .where(
          (element) => element['_id'] != id,
        )
        .toList();
    if (response.statusCode == 200) {
      setState(() {
        items = filtered;
      });
    } else {
      Snakebar.snakeBar('Delet faild', Colors.red, context);
    }
  }

  Future<void> editData(id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('edited successfuly');
      }
    } else {
      if (kDebugMode) {
        print('faild to edit');
      }
    }
  }

  Future<void> navigatoToEditPage(Map item) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTaskScreen(todo: item),
        ));
    setState(() {
      refreshed = true;
    });
    fethcData();
  }

  Future<void> navigatoToAddPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddTaskScreen(),
        ));
    setState(() {
      refreshed = true;
    });
    fethcData();
  }
}

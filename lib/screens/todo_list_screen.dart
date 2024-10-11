import 'package:flutter/material.dart';
import 'package:paymob/screens/widgets/item.dart';
import 'package:paymob/servise/api_service.dart';
import 'package:paymob/util/snakebar.dart';
import 'package:paymob/screens/add_task_screen.dart';

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
  List<dynamic> items = [];
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
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'There is no Tasks add some',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: ListView.builder(
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Item(
                        item: item,
                        index: index,
                        deletData: deletData,
                        navigatoToEditPage: navigatoToEditPage));
              },
              itemCount: items.length,
            ),
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
    final result = await ApiService.fetchData();
    setState(() {
      items = result!;
      refreshed = true;
    });
  }

  Future<void> deletData(id) async {
    final success = await ApiService.deletData(id);
    if (success) {
      final filtered = items
          .where(
            (element) => element['_id'] != id,
          )
          .toList();
      setState(() {
        items = filtered;
      });
    } else {
      Snakebar.snakeBar('Delet faild', Colors.red, context);
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

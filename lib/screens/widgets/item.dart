import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  Map item;
  int index;
  Function deletData;
  Function navigatoToEditPage;
  Item({
    super.key,
    required this.item,
    required this.index,
    required this.deletData,
    required this.navigatoToEditPage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shcoolapp/%08widgets/todo_item.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController _todoController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Todo-List',
          style: TextStyle(fontFamily: 'salt', fontSize: 30),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text(
                          '할 일',
                          style: TextStyle(fontFamily: 'salt', fontSize: 30),
                        ),
                        actions: [
                          Column(
                            children: [
                              TextField(
                                controller: _todoController,
                                decoration: const InputDecoration(
                                    hintText: ('할 일을 입력하세요'),
                                    hintStyle: TextStyle(
                                        fontFamily: 'salt', fontSize: 20)),
                              ),
                            ],
                          ),
                          IconButton(
                              alignment: Alignment.bottomRight,
                              onPressed: () =>
                                  _addTodo(TodoItems(_todoController.text)),
                              icon: const Icon(Icons.add_box_outlined))
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('todo').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final documents = snapshot.data!.docs;
                  return Expanded(
                    child: ListView(
                      children:
                          documents.map((doc) => _buildItem(doc)).toList(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(DocumentSnapshot snapshot) {
    final todo = TodoItems(
      snapshot['title'],
      isDone: snapshot['isDone'],
    );
    return ListTile(
      title: Text(
        todo.title,
        style: todo.isDone
            ? const TextStyle(
                decoration: TextDecoration.lineThrough,
                fontFamily: 'salt',
                fontSize: 30)
            : const TextStyle(fontFamily: 'salt', fontSize: 30),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () => _deleteTodo(snapshot),
      ),
      onTap: () => _toggleTodo(snapshot),
    );
  }

  void _addTodo(TodoItems todo) {
    setState(() {
      FirebaseFirestore.instance
          .collection('todo')
          .add({'title': todo.title, 'isDone': todo.isDone});
      _todoController.text = "";
    });
  }

  void _deleteTodo(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance.collection('todo').doc(snapshot.id).delete();
  }

  void _toggleTodo(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('todo')
        .doc(snapshot.id)
        .update({'isDone': !snapshot['isDone']});
  }
}

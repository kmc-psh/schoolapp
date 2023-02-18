import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shcoolapp/%08widgets/todo_item.dart';
import 'package:shcoolapp/page/calendarpage.dart';

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
        title: Text('남은 할 일'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarPage()));
              },
              icon: Icon(Icons.fork_right))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                  ),
                ),
                ElevatedButton(
                  child: Text('추가'),
                  onPressed: () => _addTodo(TodoItems(_todoController.text)),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('todo').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
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
    final todo = TodoItems(snapshot['title'], isDone: snapshot['isDone']);
    return ListTile(
      title: Text(
        todo.title,
        style: todo.isDone
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                fontStyle: FontStyle.italic,
              )
            : null,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever),
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

// void _deleteTodo(DocumentSnapshot snapshot) {
//   FirebaseFirestore.instance
//       .collection('todo')
//       .doc(snapshot.documentID)
//       .delete();
// }

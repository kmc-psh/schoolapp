import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shcoolapp/%08widgets/todo_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  String title = "";
  String task = "";

  List<TodoItems> todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ToDo-List',
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("Todo-List"),
                        actions: [
                          Column(
                            children: [
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    title = value;
                                  });
                                },
                                decoration:
                                    const InputDecoration(hintText: '할 일'),
                              ),
                              TextField(
                                onChanged: (value) {
                                  task = value;
                                },
                                decoration: const InputDecoration(
                                    hintText: '내용을 입력해주세요'),
                              ),
                            ],
                          ),
                          IconButton(
                              alignment: Alignment.bottomRight,
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  todos
                                      .add(TodoItems(title: title, task: task));
                                });
                              },
                              icon: Icon(Icons.add_box)),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemBuilder: ((_, index) {
          return InkWell(
            child: ListTile(
              title: Text(todos[index].title),
              subtitle: Text(todos[index].task),
            ),
          );
        }),
        itemCount: todos.length,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/api/user_api.dart';
import 'package:shcoolapp/page/addPostScreen.dart';
import 'package:shcoolapp/provider/board_provider.dart';

class BoardScreen extends StatefulWidget {
  final String id;
  const BoardScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시판'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddPostScreen(id: id)));
          },
          child: Text(widget.id),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPostScreen(id: widget.id)));
                },
                child: Text(widget.id),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('board').snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => listTitle(
                        snapshot.data!.docs[index]['title'],
                        snapshot.data!.docs[index]['content']),
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  );
                }))
          ],
        ),
      ),
    );
  }
}

Widget listTitle(String title, String content) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: GestureDetector(
      onTap: () {
        print('#########');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '제목 : $title',
            style: const TextStyle(fontSize: 15.0, color: Colors.black),
          ),
          Text(
            '내용 : $content',
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 15.0, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

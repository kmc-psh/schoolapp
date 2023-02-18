import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shcoolapp/utils/chatmessage.dart';

class ChatMain extends StatefulWidget {
  ChatMain({required this.room, required this.name, super.key});
  var room;
  String name;
  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: MessageText(
                room: widget.room,
                name: widget.name,
              ),
            ),
            SendMessage(
              room: widget.room,
              name: widget.name,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageText extends StatelessWidget {
  MessageText({required this.room, required this.name, super.key});
  var room;
  String name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .doc(name)
          .collection('RoomName')
          .doc(room)
          .collection('message')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            return TestWdiget(name, snapshot.data!.docs[index]['name'],
                snapshot.data!.docs[index]['text']);
          },
        );
      },
    );
  }
}

class SendMessage extends StatefulWidget {
  SendMessage({required this.room, required this.name, super.key});
  var room;
  String name;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

TextEditingController _textEditingController = TextEditingController();

class _SendMessageState extends State<SendMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // Expanded는 사이즈 고정 + row column에서만 사용
          Expanded(
            child: TextField(
              controller: _textEditingController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(hintText: "Send a Message"),
              // onSubmitted는 _handleSubmitted와 같이 (String text) 구조로 이루어져 있으므로
              // onSubmitted: _handleSubmitted,처럼 바로 묶어주면 된다.
            ),
          ),
          IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('chat')
                    .doc(widget.name)
                    .collection('RoomName')
                    .doc(widget.room)
                    .collection('message')
                    .add({
                  'text': _textEditingController.text,
                  'name': widget.name,
                  'time': Timestamp.now()
                });
                _textEditingController.clear();
              },
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}

Widget TestWdiget(String name, String _name, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment:
          name == _name ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          // backgroundImage: widget.pickedImage != null
          //     ? FileImage(widget.pickedImage!)
          //     : null,
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // txt에 들어있는 정보를 보여준다.
            Text(text)
          ],
        ),
      ],
    ),
  );
}

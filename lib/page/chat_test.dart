import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shcoolapp/utils/chatmessage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  String name;
  ChatScreen({required this.name, Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = widget.name;
      if (user != null) {}
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat screen'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              //Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ChatTest(
                name: widget.name,
              ),
            ),
            NewMessage(name: widget.name),
          ],
        ),
      ),
    );
  }
}

class ChatTest extends StatefulWidget {
  String name;
  ChatTest({required this.name, Key? key}) : super(key: key);

  @override
  State<ChatTest> createState() => _ChatTestState();
}

class _ChatTestState extends State<ChatTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
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
            return ChatBubble(chatDocs[index]['text'],
                chatDocs[index]['userID'].toString() == widget.name);
          },
        );
      },
    ));
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble(this.message, this.isMe, {Key? key}) : super(key: key);

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Colors.blue,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0)),
          ),
          width: 145,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
          ),
        ),
      ],
    );
  }
}

class NewMessage extends StatefulWidget {
  String name;
  NewMessage({required this.name, Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  void _sendMessage() {
    FocusScope.of(context).unfocus();
    // final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('chat').add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': widget.name,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

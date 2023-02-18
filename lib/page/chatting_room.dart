import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shcoolapp/%08widgets/chattingroom_item.dart';
import 'package:shcoolapp/page/chattingpage.dart';
import 'package:shcoolapp/test.dart';

class ChattingRoom extends StatefulWidget {
  final String name;
  String room = '';

  ChattingRoom({required this.room, required this.name, super.key});

  @override
  State<ChattingRoom> createState() => _ChattingRoomState();
}

class _ChattingRoomState extends State<ChattingRoom> {
  List<ChattingRoomItems> roomName = [];

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatting Room'),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('방 만들기'),
                      actions: [
                        Column(
                          children: [
                            TextField(
                              // controller: _textEditingController,
                              onChanged: (value) {
                                setState(
                                  () {
                                    widget.room = value;
                                  },
                                );
                              },

                              decoration: const InputDecoration(
                                  hintText: '방 이름을 정해주세요'),
                            ),
                          ],
                        ),
                        IconButton(
                            alignment: Alignment.bottomRight,
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                roomName.add(
                                  ChattingRoomItems(room: widget.room),
                                );
                                FirebaseFirestore.instance
                                    .collection('chat')
                                    .doc(
                                        'name: ${widget.name}, room: ${widget.room}')
                                    .set({'RoomName': widget.room});
                              });
                            },
                            icon: const Icon(Icons.add_box))
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('chat').snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = snapshot.data!.docs;
            return ListView.builder(
              itemBuilder: ((context, index) {
                return InkWell(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            // roomName[index].room,
                            snapshot.data!.docs[index]['RoomName'],
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              roomName.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             ChattingPage(name: widget.name, room: widget.room)));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatMain(
                                  room: roomName[index].room,
                                  name: widget.name,
                                )));
                  },
                );
              }),
              itemCount: chatDocs.length,
            );
          })),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shcoolapp/%08widgets/chattingroom_item.dart';

class ChattingRoom extends StatefulWidget {
  const ChattingRoom({super.key});

  @override
  State<ChattingRoom> createState() => _ChattingRoomState();
}

class _ChattingRoomState extends State<ChattingRoom> {
  String room = '';
  List<ChattingRoomItems> roomName = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatting Room'),
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
                              onChanged: (value) {
                                setState(
                                  () {
                                    room = value;
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
                                  ChattingRoomItems(room: room),
                                );
                                Future<DocumentReference<Map<String, dynamic>>>
                                    users = FirebaseFirestore.instance
                                        .collection(room)
                                        .add({});
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
      body: ListView.builder(
        itemBuilder: ((_, index) {
          return InkWell(
            child: ListTile(
              title: Text(roomName[index].room),
            ),
            onTap: () {},
          );
        }),
        itemCount: roomName.length,
      ),
    );
  }
}

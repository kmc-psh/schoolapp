import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/%08widgets/chattingroom_item.dart';
import 'package:shcoolapp/controller/user_controller.dart';
import 'package:shcoolapp/page/chattingpage.dart';
import 'package:shcoolapp/test.dart';

class ChattingRoom extends StatefulWidget {
  final String? name;
  String? email;
  String? room = '';
  int? pk;

  ChattingRoom(
      {required this.room, required this.name, this.email, this.pk, super.key});

  @override
  State<ChattingRoom> createState() => _ChattingRoomState();
}

class _ChattingRoomState extends State<ChattingRoom> {
  List<ChattingRoomItems> roomName = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    TextEditingController _textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatting Room',
            style: TextStyle(
                fontFamily: 'salt', color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.black,
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
                      title: const Text(
                        '방 만들기',
                        style: TextStyle(fontFamily: 'salt', fontSize: 30),
                      ),
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
                                  hintText: '방 이름을 정해주세요',
                                  hintStyle: TextStyle(
                                      fontFamily: 'salt', fontSize: 20)),
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
                                    .set({
                                  'RoomName': widget.room,
                                  'name': widget.name
                                });
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // final chatDocs = snapshot.data!.docs;
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
                                fontFamily: 'salt',
                                color: Colors.black,
                                fontSize: 30),
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
                  onTap: () async {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             ChattingPage(name: widget.name, room: widget.room)));

                    // var provider = UserProvider();
                    await provider.fetchUserData(widget.email);
                    String imageUrl = "provider.userModel.image";
                    if (mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatMain(
                                  room: snapshot.data!.docs[index]['RoomName'],
                                  name: widget.name,
                                  test: snapshot.data!.docs[index]['name'],
                                  email: widget.email,
                                  pk: widget.pk,
                                  imageUrl: imageUrl)));
                    }
                  },
                );
              }),
              itemCount: snapshot.data!.docs.length,
            );
          })),
    );
  }
}

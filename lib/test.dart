import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shcoolapp/controller/kakao_controller.dart';
import 'package:shcoolapp/utils/chatmessage.dart';

class ChatMain extends StatefulWidget {
  ChatMain(
      {required this.room,
      required this.name,
      required this.test,
      this.email,
      this.pk,
      super.key});
  var room;
  String? name;
  String? test;
  String? email;
  int? pk;
  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  File? _pickedImage;
  late String imageUrl = '';

  Future<String> _uploadImage(File image) async {
    var controller = LoginProvider();
    final firebaseStorageRef = FirebaseStorage.instance;

    var test = firebaseStorageRef
        .ref()
        .child('profile/${widget.name}/')
        .putFile(image);

    final downloadUrl = await firebaseStorageRef
        .ref()
        .child('profile/${widget.name}')
        .getDownloadURL();
    print('############## $downloadUrl');

    FirebaseFirestore.instance.collection('회원정보').doc(widget.email).set({
      'pk': widget.pk,
      '카카오 계정': controller.test,
      '카카오 프로필': widget.name,
      '프로필 이미지': downloadUrl
    });

    String imageUrl = await FirebaseFirestore.instance
        .collection('회원정보')
        .doc(widget.email)
        .get()
        .then((value) {
      print(value.data());
      dynamic test = value.data();
      print(test['pk']);

      String imageUrl = test['프로필 이미지'];
      print(imageUrl);
      return imageUrl;
    });
    return imageUrl;
  }

  Future<File> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxHeight: 150);
    setState(() {
      if (pickedImageFile != null) {
        _pickedImage = File(pickedImageFile.path);
      }
    });
    return _pickedImage!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text('이미지 설정하기'),
                        actions: [
                          Column(
                            children: [
                              OutlinedButton.icon(
                                  onPressed: () async {
                                    File image = await _pickImage();
                                    imageUrl = await _uploadImage(image);
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.image),
                                  label: const Text('사진 추가하기'))
                            ],
                          )
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: MessageText(
                room: widget.room,
                name: widget.name,
                test: widget.test,
                pickedImage: _pickedImage,
                imageUrl: imageUrl,
              ),
            ),
            SendMessage(
              room: widget.room,
              name: widget.name,
              test: widget.test,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageText extends StatelessWidget {
  MessageText(
      {required this.room,
      required this.name,
      required this.test,
      this.pickedImage,
      this.imageUrl,
      super.key});
  var room;
  String? name;
  String? test;
  File? pickedImage;
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .doc('name: $test, room: $room')
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
            return TestWdiget(snapshot.data!.docs[index]['name'], name,
                snapshot.data!.docs[index]['text'], pickedImage, imageUrl);
          },
        );
      },
    );
  }
}

class SendMessage extends StatefulWidget {
  SendMessage(
      {required this.room, required this.name, required this.test, super.key});
  var room;
  String? name;
  String? test;

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
                    .doc('name: ${widget.test}, room: ${widget.room}')
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

Widget TestWdiget(String? name, String? _name, String text, File? pickedImage,
    String? imageUrl) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment:
          name == _name ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          // backgroundImage: pickedImage != null ? FileImage(pickedImage) : null,
          child: imageUrl != null ? Image.network(imageUrl) : SizedBox(),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name!,
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

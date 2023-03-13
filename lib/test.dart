import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/controller/kakao_controller.dart';
import 'package:shcoolapp/controller/user_controller.dart';
import 'package:shcoolapp/utils/chatmessage.dart';

class ChatMain extends StatefulWidget {
  ChatMain(
      {required this.room,
      required this.name,
      required this.test,
      this.email,
      this.pk,
      this.imageUrl,
      super.key});
  var room;
  String? name;
  String? test;
  String? email;
  int? pk;
  String? imageUrl;
  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  File? _pickedImage;
  String? imageUrl;

  Future<String> _uploadImage(File image) async {
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

    await FirebaseFirestore.instance.collection('회원정보').doc(widget.email).set({
      'pk': widget.pk,
      '카카오 계정': widget.email,
      '카카오 프로필': widget.name,
      '프로필 이미지': downloadUrl
    });

    dynamic imgTest = await FirebaseFirestore.instance
        .collection('회원정보')
        .doc(widget.email)
        .get();

    String imageUrl = imgTest['프로필 이미지'];

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

  getImage() async {
    var test = await FirebaseFirestore.instance
        .collection('회원정보')
        .get()
        .then((QuerySnapshot) {
      for (var docSnapshot in QuerySnapshot.docs) {
        print('${docSnapshot.data()}');
        var test2 = docSnapshot.data();
        print("test2['프로필 이미지']");
      }
    });
  }

  // jokka() async {
  //   if (pk == userPk) {
  //     await FirebaseFirestore.instance
  //         .collection('회원정보')
  //         .get()
  //         .then((QuerySnapshot) {
  //       for (var docSnapshot in QuerySnapshot.docs) {
  //         // print('${docSnapshot.data()}');
  //         dynamic userData = docSnapshot.data();
  //         imgUrl = userData['프로필 이미지'];
  //       }
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    print("########1 test ${provider.userModel.profile}");
    String testUrl = "provider.userModel.image";
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
                                    String testImg = await _uploadImage(image);
                                    UserProvider().fetchUserData(widget.email);
                                    await getImage();
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
                // imageUrl: widget.imageUrl,
                imageUrl: testUrl,
                pk: widget.pk,
                email: widget.email,
              ),
            ),
            SendMessage(
              room: widget.room,
              name: widget.name,
              test: widget.test,
              pk: widget.pk,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageText extends StatefulWidget {
  MessageText(
      {required this.room,
      required this.name,
      required this.test,
      this.pickedImage,
      this.imageUrl,
      this.pk,
      this.email,
      super.key});
  var room;
  String? name;
  String? test;
  File? pickedImage;
  String? imageUrl;
  int? pk;
  String? email;

  @override
  State<MessageText> createState() => _MessageTextState();
}

class _MessageTextState extends State<MessageText> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    print('!!!!!!! ${provider.userModel.email}');
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .doc('name: ${widget.test}, room: ${widget.room}')
            .collection('RoomName')
            .doc(widget.room)
            .collection('message')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              // UserProvider().fetchAllData(snapshot.data?.docs[index]['pk']);
              return provider.userModel.pk == snapshot.data?.docs[index]['pk']
                  // ? Text("참 #### ${snapshot.data?.docs[index]['name']}")
                  // : Text("거짓 #### ${snapshot.data?.docs[index]['name']}");
                  // 채팅 데이터들 안에 유저의 pk 값 존재함 => 회원정보에도 pk 값 존재 : 비교할 수 있음
                  // 채팅 데이터 pk == 회원정보 pk => 회원정보 안의 이미지 url 을 받아와서 전달 가능 ?.?
                  ? TestWdiget(
                      widget.name,
                      snapshot.data?.docs[index]['name'],
                      snapshot.data?.docs[index]['text'],
                      widget.pickedImage,
                    )
                  : TestWdiget(
                      widget.name,
                      snapshot.data?.docs[index]['name'],
                      snapshot.data?.docs[index]['text'],
                      widget.pickedImage,
                    );
            },
          );
        });
  }
}

// class MessageText extends StatelessWidget {
//   MessageText(
//       {required this.room,
//       required this.name,
//       required this.test,
//       this.pickedImage,
//       this.imageUrl,
//       this.pk,
//       this.email,
//       super.key});
//   var room;
//   String? name;
//   String? test;
//   File? pickedImage;
//   String? imageUrl;
//   int? pk;
//   String? email;

//   getImage(String? email, int userPk) async {
//     dynamic test =
//         await FirebaseFirestore.instance.collection('회원정보').doc(email).get();
//     if (test['pk'] == userPk) {
//       imageUrl = test['프로필 이미지'];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var provider = Provider.of<UserProvider>(context);
//     print('!!!!!!! ${provider.userModel.email}');
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('chat')
//             .doc('name: $test, room: $room')
//             .collection('RoomName')
//             .doc(room)
//             .collection('message')
//             .orderBy('time', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           return ListView.builder(
//             reverse: true,
//             itemCount: snapshot.data?.docs.length,
//             itemBuilder: (context, index) {
//               // UserProvider().fetchAllData(snapshot.data?.docs[index]['pk']);
//               return provider.userModel.pk == snapshot.data?.docs[index]['pk']
//                   // ? Text("참 #### ${snapshot.data?.docs[index]['name']}")
//                   // : Text("거짓 #### ${snapshot.data?.docs[index]['name']}");
//                   // 채팅 데이터들 안에 유저의 pk 값 존재함 => 회원정보에도 pk 값 존재 : 비교할 수 있음
//                   // 채팅 데이터 pk == 회원정보 pk => 회원정보 안의 이미지 url 을 받아와서 전달 가능 ?.?
//                   ? TestWdiget(
//                       name,
//                       snapshot.data?.docs[index]['name'],
//                       snapshot.data?.docs[index]['text'],
//                       pickedImage,
//                     )
//                   : TestWdiget(
//                       name,
//                       snapshot.data?.docs[index]['name'],
//                       snapshot.data?.docs[index]['text'],
//                       pickedImage,
//                     );
//             },
//           );
//         });
//   }
// }

class SendMessage extends StatefulWidget {
  SendMessage(
      {required this.room,
      required this.name,
      required this.test,
      this.pk,
      super.key});
  var room;
  String? name;
  String? test;
  int? pk;

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
                  'time': Timestamp.now(),
                  'pk': widget.pk,
                });
                _textEditingController.clear();
              },
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}

Widget TestWdiget(
  String? name,
  String? myName,
  String? text,
  File? pickedImage,
) {
  // var provider = UserProvider();
  // provider.fetchAllData();
  // print('${provider.userModel.profile}');
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment:
          name == myName ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          // backgroundImage: pickedImage != null ? FileImage(pickedImage) : null,
          // child: imageUrl == '' ? SizedBox() : Image.network(imageUrl!),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              myName!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // txt에 들어있는 정보를 보여준다.
            Text(
              text!,
              maxLines: 3,
            )
          ],
        ),
      ],
    ),
  );
}

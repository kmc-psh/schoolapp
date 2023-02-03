import 'dart:io';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatMessage extends StatefulWidget {
  final String txt;

  // 애니메이션 변수 생성
  final Animation<double> animation;
  final String name;
  File? pickedImage;
  ChatMessage(this.txt, this.name, this.pickedImage,
      {required this.animation, super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  // File? pickedImage;

  // void _pickImage() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImageFile = await imagePicker.pickImage(
  //       source: ImageSource.camera, imageQuality: 50, maxHeight: 150);
  //   setState(() {
  //     if (pickedImageFile != null) {
  //       pickedImage = File(pickedImageFile.path);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // 로우로 묶어주고 로우안에 컬럼을 넣어준다.
    return Padding(
      // 패딩의 symmetric에는 수평 수직 범위를 지정해준다
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: FadeTransition(
        // 애니메이션이 흐리다가 점차 밝아짐
        opacity: widget.animation,
        child: SizeTransition(
          // axisAlignment -1로 설정시 애니메이션이 아래에서 올라온다.
          sizeFactor: widget.animation,
          axisAlignment: -1,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: widget.pickedImage != null
                    ? FileImage(widget.pickedImage!)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // txt에 들어있는 정보를 보여준다.
                    Text(widget.txt)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

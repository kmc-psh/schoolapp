import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/pagenotifier.dart';

class StudentPage extends Page {
  static final String pageName = 'StudentPage';

  // 스튜던트 위젯으로 가는 루트 생성
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this, builder: (context) => StudentWidget());
  }
}

class StudentWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StudentWidgetState();
}

class _StudentWidgetState extends State<StudentWidget> {
  //dart.io를 사용
  File? _image;

//변수 저장
  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    // 가져온 이미지를 _image에 저장
    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Row(
            children: [
              const Text(
                "학생증 인증",
                textScaleFactor: 3,
                style: TextStyle(fontFamily: 'salt', color: Colors.white),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    // Provider.of<PageNotifier>(context, listen: false)
                    //     .goToOtherPage('AuthPage');
                  },

                  // 편의상 만든거고 나중에 삭제할 것!!
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  label: Text('')),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SafeArea(
            child: Column(
              children: [
                //imagepicker사용해서 카메라 기능 구현
                ElevatedButton.icon(
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera_alt_outlined),
                  label: Text(
                    '학생증을 찍어주세요',
                    style: TextStyle(
                        fontFamily: 'salt', color: Colors.white, fontSize: 30),
                  ),
                ),
                // 사진 클릭 시 사진 확대되게 하고, 컨테이너 사이즈에 사진크기가 맞게 설정해보자
                Container(
                  color: Colors.white,
                  width: 300,
                  height: 200,
                  child: Center(
                    child: _image == null
                        ? Text(
                            '학생증 사진이 없어요 ㅠㅠ.',
                            style: TextStyle(
                                fontFamily: 'salt',
                                color: Colors.black,
                                fontSize: 30),
                          )
                        : Image.file(File(_image!.path)),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('전송'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/pagenotifier.dart';

// 회원가입 버튼
class AuthPage extends Page {
  // 페이지로 가는 키워드 생성
  static final String pageName = 'AuthPage';

  @override
  Route createRoute(BuildContext context) {
    // AuthWidget으로가는 루트 생성, setting: this(기본 세팅 적용)
    return MaterialPageRoute(
        settings: this, builder: (context) => AuthWidget());
  }
}

class AuthWidget extends StatefulWidget {
  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  OutlineInputBorder _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(color: Colors.white),
  );

  // // 카메라 기능
  // static const routeName = '/getimage';
  //
  // File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(30),
          children: [
            Text("회원가입",
                textScaleFactor: 3,
                style: TextStyle(fontFamily: 'salt', color: Colors.white)),
            TextFormField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  icon: Icon(
                    Icons.looks_one_outlined,
                    color: Colors.blue,
                  ),
                  border: _border,
                  focusedBorder: _border,
                  hintText: '이름',
                  hintStyle: TextStyle(
                    color: Colors.blue,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  icon: Icon(
                    Icons.looks_two_outlined,
                    color: Colors.blue,
                  ),
                  border: _border,
                  focusedBorder: _border,
                  hintText: '학교명',
                  hintStyle: TextStyle(color: Colors.blue)),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  icon: Icon(
                    Icons.looks_3_outlined,
                    color: Colors.blue,
                  ),
                  border: _border,
                  focusedBorder: _border,
                  hintText: '학번',
                  hintStyle: TextStyle(color: Colors.blue)),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  icon: Icon(
                    Icons.looks_4_outlined,
                    color: Colors.blue,
                  ),
                  border: _border,
                  focusedBorder: _border,
                  hintText: '이메일',
                  hintStyle: TextStyle(color: Colors.blue)),
            ),
            SafeArea(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt_outlined),
                    label: Text(
                      '학생증을 찍어주세요',
                      style: TextStyle(
                          fontFamily: 'salt',
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                  // 카메라 기능
                  // showImage()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
// 카메라 기능
// Widget showImage(){
//   if (_image == null)
//     return Container();
//   else
//     return Image.file(_image);
//
//
// }

// 카메라 기능
// Future getImage(ImageSource imageSource) async {
//   var image = await ImagePicker.platform.pickImage(source: ImageSource.camera);
//
//   setState(() {
//     _image = image;
//   });
// }

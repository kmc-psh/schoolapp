import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/page/studentIDpage.dart';
import '../provider/pagenotifier.dart';
import 'dart:io';

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
  //밸리데이션 기능을 작동시키기위해 글로벌키 생성
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userID = '';
  String userEmail = '';
  String userPassword = '';

  // 모든 텍스트폼필드를 작동시키기위해 currentstate에 의해서만 벨리데이트가 호출되므로 널값(!)표시해주기
  void _tryValidation(){
    final isVaild = _formKey.currentState!.validate();
    if(isVaild){
      _formKey.currentState!.save();
    }
  }
  //dart.io를 사용
  // File? _image;

  //변수 저장
  // final picker = ImagePicker();
  //
  // Future getImage(ImageSource imageSource) async {
  //   final image = await picker.pickImage(source: imageSource);
  //
  //   // 가져온 이미지를 _image에 저장
  //   setState(() {
  //     _image = File(image!.path);
  //   });
  // }

  OutlineInputBorder _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(30),
          children: [
            Row(
              children: [
                Text(
                  "회원가입",
                  textScaleFactor: 3,
                  style: TextStyle(fontFamily: 'salt', color: Colors.white),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<PageNotifier>(context, listen: false)
                          .goToMain();
                    },

                    // 편의상 만든거고 나중에 삭제할 것!!
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    label: Text('')),
              ],
            ),
            TextFormField(
              key: ValueKey(1),
              validator: (value){
                // !로 null값 허용
                if (value!.isEmpty || !value.contains('@')){
                  return '너무 짧아요';
                }
                return null;
              },
              onSaved: (value){
                userEmail = value!;
              },
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
                  hintText: '이메일',
                  hintStyle: TextStyle(
                    color: Colors.blue,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              key: ValueKey(2),
              validator: (value){
                // !로 null값 허용
                if (value!.isEmpty || value.length < 4){
                  return '5글자 이상으로 해주세요';
                }
                return null;
              },
              onSaved: (value){
                userID = value!;
              },
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
                  hintText: '아이디',
                  hintStyle: TextStyle(color: Colors.blue)),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              key: ValueKey(3),
              validator: (value){
                // !로 null값 허용
                if (value!.isEmpty || value.length < 6){
                  return '7글자 이상으로 해주세요';
                }
                return null;
              },
              onSaved: (value){
                userPassword = value!;
              },
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
                  hintText: '비밀번호',
                  hintStyle: TextStyle(color: Colors.blue)),
            ),
            SizedBox(
              height: 20,
            ),
            // TextFormField(
            //   key: ValueKey(4),
            //   validator: (value){
            //     // !로 null값 허용
            //     if (){
            //       return '비밀번호가 일치하지 않아요';
            //     }
            //     return null;
            //   },
            //   cursorColor: Colors.black,
            //   decoration: InputDecoration(
            //       filled: true,
            //       fillColor: Colors.white,
            //       icon: Icon(
            //         Icons.looks_4_outlined,
            //         color: Colors.blue,
            //       ),
            //       border: _border,
            //       focusedBorder: _border,
            //       hintText: '비밀번호 확인',
            //       hintStyle: TextStyle(color: Colors.blue)),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // TextFormField(
            //   cursorColor: Colors.black,
            //   decoration: InputDecoration(
            //       filled: true,
            //       fillColor: Colors.white,
            //       icon: Icon(
            //         Icons.looks_5_outlined,
            //         color: Colors.blue,
            //       ),
            //       border: _border,
            //       focusedBorder: _border,
            //       hintText: '',
            //       hintStyle: TextStyle(color: Colors.blue)),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // TextFormField(
            //   cursorColor: Colors.black,
            //   decoration: InputDecoration(
            //       filled: true,
            //       fillColor: Colors.white,
            //       icon: Icon(
            //         Icons.looks_4_outlined,
            //         color: Colors.blue,
            //       ),
            //       border: _border,
            //       focusedBorder: _border,
            //       hintText: '',
            //       hintStyle: TextStyle(color: Colors.blue)),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // TextFormField(
            //   cursorColor: Colors.black,
            //   decoration: InputDecoration(
            //       filled: true,
            //       fillColor: Colors.white,
            //       icon: Icon(
            //         Icons.looks_4_outlined,
            //         color: Colors.blue,
            //       ),
            //       border: _border,
            //       focusedBorder: _border,
            //       hintText: '',
            //       hintStyle: TextStyle(color: Colors.blue)),
            // ),
            // SafeArea(
            //   child: Column(
            //     children: [
            // imagepicker사용해서 카메라 기능 구현
            // ElevatedButton.icon(
            //   onPressed: () {
            //     getImage(ImageSource.camera);
            //   },
            //   icon: Icon(Icons.camera_alt_outlined),
            //   label: Text(
            //     '학생증을 찍어주세요',
            //     style: TextStyle(
            //         fontFamily: 'salt',
            //         color: Colors.white,
            //         fontSize: 30),
            //   ),
            // ),

            // 사진 클릭 시 사진 확대되게 하고, 컨테이너 사이즈에 사진크기가 맞게 설정해보자
            // Container(
            //   color: Colors.white,
            //   width: 300,
            //   height: 200,
            //   child: Center(
            //       child: _image == null
            //           ? Text(
            //               '학생증 사진이 없어요 ㅠㅠ.',
            //               style: TextStyle(
            //                   fontFamily: 'salt',
            //                   color: Colors.black,
            //                   fontSize: 30),
            //             )
            //           : Image.file(File(_image!.path))),
            // ),

            SizedBox(
              height: 20,
            ),

            // 위의 항목이 잘못되거나 빠진 부분이 있을경우 완료버튼이 경고창이 뜨며 실패한다
            // 위의 항목이 잘 입력되면 끝버튼이 눌리고 url서버로 전송시킨다.
            // 그리고 가입신청이 완료 되었다는 문구가 나온다.
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                // 버튼에 학생증 인증 페이지로 넘어가는 기능과 _tryValidation();기능 같이 추가하기
                  onPressed: () {
                    // if (isVaild == null){
                    //   return Provider.of<PageNotifier>(context, listen: false)
                    //       .goToOtherPage('StudentPage');
                    // } else {
                    //   return _tryValidation();
                    // }
                    // _tryValidation();
                    // Provider.of<PageNotifier>(context, listen: false)
                    //     .goToOtherPage('StudentPage');

                  },
                  icon: Icon(
                    Icons.arrow_forward,
                  ),
                  label: Text('NEXT')),
            ),
          ],
        ),
      ),
      //       ],
      //     ),
      //   ),
    );

  }


}

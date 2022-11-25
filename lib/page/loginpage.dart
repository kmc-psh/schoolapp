import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/api/user_api.dart';
import 'package:shcoolapp/kakaoviewmodel.dart';
import 'package:shcoolapp/page/authpage.dart';
import 'package:shcoolapp/provider/pagenotifier.dart';
import 'package:shcoolapp/utils/kakaoutils.dart';

class LoginPage extends StatefulWidget {
  static final String pageName = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // form 글로벌 키 생성
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String inputId = '';
  String inputPw = '';

  //id 받아오기
  OutlineInputBorder _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(color: Colors.white));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //id or pw창 만들 때 form을 만들어 좀 더 쉽게 구현 가능
      body: Form(
        // 해당 form안에 유저 id와 pw를 입력했을 때 입력한 값이 잘 입력되었는지 확인하기 위해 사용한다.
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(height: 50),
            Container(
              child: Image.asset(
                'assets/student.png',
                height: 170,
              ),
            ),
            //
            //     SizedBox(height: 50),
            //
            //     Text(
            //       "앱에 대한 설명",
            //       textAlign: TextAlign.center,
            //       textScaleFactor: 4,
            //       style:
            //           TextStyle(fontFamily: 'salt', color: Colors.white),
            //     ),

            // SizedBox(height: 100),
            TextFormField(
              onChanged: (id) {
                setState(() {
                  inputId = id;
                });
              },
              cursorColor: Colors.black,
              // controller: _idController,
              validator: (text) {
                // if (text == null || text.isEmpty) {
                //   return '입력창이 비었음';
                // }
                // return null;
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  icon: Icon(
                    Icons.face_retouching_natural,
                    color: Colors.blue,
                  ),
                  border: _border,
                  focusedBorder: _border,
                  hintText: 'id',
                  hintStyle: TextStyle(color: Colors.blue)),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: ((pw) {
                setState(() {
                  inputPw = pw;
                });
              }),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  icon: Icon(
                    Icons.lock_outlined,
                    color: Colors.blue,
                  ),
                  border: _border,
                  focusedBorder: _border,
                  hintText: 'password',
                  hintStyle: TextStyle(color: Colors.blue)),
            ),

            SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () {},
              child: Text('login'),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<PageNotifier>(context, listen: false)
                        .goToOtherPage(AuthPage.pageName);
                  },
                  child: Text('회원가입'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('id/pw 찾기'),
                ),
                // 이미지가 있으면 가져오고 없으면 빈값으로 가져온다
              ],
            ),
            ElevatedButton(
              onPressed: () {
                UserController().addPost(inputId, inputPw);
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                checkLogin();
                setState(() {});
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

void checkLogin() async {
  if (await isKakaoTalkInstalled()) {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공');
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  } else {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공');
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}

// void kakaologinControl(String accessToken) async {
  
//     final response = await repository.kakaoLogin(accessToken);

//     //print(response);
//     if (response['error']) {
//       // Get.toNamed('/agreement');
//       //error ==> ??? Toast?

//     } else {
//       if (response['status'] == 200) {
//         // 메인화면 이동
//         Get.toNamed('/home');
//       } else {
//         // error : false , status 200 이 아닌경우 ,,
//       }
//     }
//   }

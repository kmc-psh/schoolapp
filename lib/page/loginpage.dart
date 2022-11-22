import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/kakaoviewmodel.dart';
import 'package:shcoolapp/page/authpage.dart';
import 'package:shcoolapp/provider/pagenotifier.dart';
import 'package:shcoolapp/utils/kakaoutils.dart';

class KakaoLogin implements KakaoUtils {
  @override
  Future<bool> login() async {
    try {
      // 카카오톡 설치 여부 확인
      bool isInstalled = await isKakaoTalkInstalled();
      // 깔려있을경우 카카오톡으로 로그인
      if (isInstalled){
        // 카카오톡으로 로그인이 안될경우 만약 뒤로가기를 누르면 catch로 빠짐
        try {
        await UserApi.instance.loginWithKakaoTalk();
        return true;
      } catch (e){
          return false;
        }
      }  else {
        try {
          // 카카오톡 계정으로 로그인 유도
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  // 로그인 실패 시 try, catch로 묶어준다.
  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;

    }
  }
}


class LoginPage extends StatefulWidget {
  static final String pageName = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // form 글로벌 키 생성
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 카카오 뷰 모델 객체 생성
  final kakaoModel = KakaoViewModel(KakaoLogin());

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
            // TextFormField(
            //   cursorColor: Colors.black,
            //   // controller: _idController,
            //   // validator: (text){
            //   //   if (text == null || text.isEmpty){
            //   //     return '입력창이 비었음';
            //   //   }
            //   //   return null;
            //   // },
            //   decoration: InputDecoration(
            //       filled: true,
            //       fillColor: Colors.white,
            //       icon: Icon(
            //         Icons.face_retouching_natural,
            //         color: Colors.blue,
            //       ),
            //       border: _border,
            //       focusedBorder: _border,
            //       hintText: 'id',
            //       hintStyle: TextStyle(color: Colors.blue)),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // TextFormField(
            //   cursorColor: Colors.black,
            //   decoration: InputDecoration(
            //       filled: true,
            //       fillColor: Colors.white,
            //       icon: Icon(
            //         Icons.lock_outlined,
            //         color: Colors.blue,
            //       ),
            //       border: _border,
            //       focusedBorder: _border,
            //       hintText: 'password',
            //       hintStyle: TextStyle(color: Colors.blue)),
            // ),
            //
            // SizedBox(height: 20,),
            //
            // ElevatedButton(onPressed: (){},child: Text('login'),),


            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         Provider.of<PageNotifier>(context, listen: false)
            //             .goToOtherPage(AuthPage.pageName);
            //       },
            //       child: Text('회원가입'),
            //     ),
            //     SizedBox(width: 10),
            //     ElevatedButton(onPressed: (){}, child: Text('id/pw 찾기'),
            //     ),
            //     // 이미지가 있으면 가져오고 없으면 빈값으로 가져온다
            //
            //   ],
            // ),
            ElevatedButton(onPressed: () async {
              await kakaoModel.login();
              setState(() {

              });

            },
              child: const Text('Login'),
            ),
            ElevatedButton(onPressed: () async{
              await kakaoModel.logout();
              setState(() {

              });

            },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

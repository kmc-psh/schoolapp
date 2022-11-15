import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/page/authpage.dart';
import 'package:shcoolapp/provider/pagenotifier.dart';

class LoginPage extends StatelessWidget {
  // form 글로벌 키 생성
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //id 받아오기
  // TextEditingController _idController = TextEditingController();




  OutlineInputBorder _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(color: Colors.white));

  // 페이지로 가는 키워드 생성
  static final String pageName = 'LoginPage';

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

            SizedBox(height: 50),

            Text(
              "앱에 대한 설명",
              textAlign: TextAlign.center,
              textScaleFactor: 4,
              style:
                  TextStyle(fontFamily: 'salt', color: Colors.white),
            ),

            SizedBox(height: 100),
            TextFormField(
              cursorColor: Colors.black,
              // controller: _idController,
              // validator: (text){
              //   if (text == null || text.isEmpty){
              //     return '입력창이 비었음';
              //   }
              //   return null;
              // },
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

            SizedBox(height: 20,),

            ElevatedButton(onPressed: (){},child: Text('login'),),


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
                ElevatedButton(onPressed: (){}, child: Text('id/pw 찾기'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

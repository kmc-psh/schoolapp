import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/controller/kakao_controller.dart';
import 'package:shcoolapp/page/chatting_room.dart';
import 'package:shcoolapp/page/mainpage.dart';

class KakaoLoginScreen extends StatefulWidget {
  const KakaoLoginScreen({super.key});

  @override
  State<KakaoLoginScreen> createState() => _KakaoLoginScreenState();
}

class _KakaoLoginScreenState extends State<KakaoLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () async {
            var provider = LoginProvider();
            String? name = await provider.kakaoLogin();
            // 카카오 로그인때 이름 안넘어오면 에러문구 설정 해야함
            if (mounted) {
              provider.targetPage == TargetPage.main
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPage(name: name)))
                  : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Center(child: Text('카카오 로그인 오류 !'))));
            }
          },
          child: Image.asset('assets/kakao.png'),
        ),
      ),
    );
  }
}

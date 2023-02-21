import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/controller/kakao_controller.dart';
import 'package:shcoolapp/page/chatting_room.dart';

class KakaoLoginScreen extends StatefulWidget {
  const KakaoLoginScreen({super.key});

  @override
  State<KakaoLoginScreen> createState() => _KakaoLoginScreenState();
}

class _KakaoLoginScreenState extends State<KakaoLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            var provider = LoginProvider();
            String? name = await provider.kakaoLogin();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChattingRoom(room: '', name: name)));
          },
          child: Text('kakao login'),
        ),
      ),
    );
  }
}

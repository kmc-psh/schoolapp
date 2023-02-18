import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/controller/kakao_controller.dart';

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
          },
          child: Image.asset(''),
        ),
      ),
    );
  }
}

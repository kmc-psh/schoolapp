// import 'package:flutter/services.dart';
// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
// import 'package:shcoolapp/page/loginpage.dart';

// class KakaoViewModel {
//   // 카카오로그인 인터페이스를 객체로 생성
//   final KakaoLogin _kakaoLogin;

//   // 로그인 상태
//   bool isLogined = false;
//   User? user;

//   //생성자에서 세팅을 해서 갖고있게 설정 Cmd + n 누르고 consturctor
//   KakaoViewModel(this._kakaoLogin);

//   // 기능 추가
//   Future login() async {
//     // isLogined가 트루면 로그인이 된 것
//     isLogined = await _kakaoLogin.login();
//     // 로그인 성공 시 유저 정보를 가져온다
//     if (isLogined) {
//       user = await UserApi.instance.me();
//       print(user);
//     }
//   }

//   Future logout() async {
//     await _kakaoLogin.logout();
//     isLogined = false;
//     user = null;
//   }
// }

// void kakaoLogin() async{
//   if (await isKakaoTalkInstalled()) {
//   try {
//       await UserApi.instance.loginWithKakaoTalk();
//       print('카카오톡으로 로그인 성공');
//   } catch (error) {
//     print('카카오톡으로 로그인 실패 $error');

//     // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
//     // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
//     if (error is PlatformException && error.code == 'CANCELED') {
//         return;
//     }
//     // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
//     try {
//         await UserApi.instance.loginWithKakaoAccount();
//         print('카카오계정으로 로그인 성공');
//     } catch (error) {
//         print('카카오계정으로 로그인 실패 $error');
//     }
//   }
// } else {
//   try {
//     await UserApi.instance.loginWithKakaoAccount();
//     print('카카오계정으로 로그인 성공');
//   } catch (error) {
//     print('카카오계정으로 로그인 실패 $error');
//   }
// }
// }
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shcoolapp/page/loginpage.dart';

class KakaoViewModel {
  // 카카오로그인 인터페이스를 객체로 생성
  final KakaoLogin _kakaoLogin;

  // 로그인 상태
  bool isLogined = false;
  User? user;



  //생성자에서 세팅을 해서 갖고있게 설정 Cmd + n 누르고 consturctor
  KakaoViewModel(this._kakaoLogin);

  // 기능 추가
  Future login() async {
    // isLogined가 트루면 로그인이 된 것
    isLogined = await _kakaoLogin.login();
    // 로그인 성공 시 유저 정보를 가져온다
    if (isLogined) {
      user = await UserApi.instance.me();
    }
  }

  Future logout() async {
    await _kakaoLogin.logout();
    isLogined = false;
    user = null;
    }
  }

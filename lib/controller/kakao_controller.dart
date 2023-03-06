import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shcoolapp/model/user_model.dart';
import 'package:shcoolapp/page/loginpage.dart';

enum TargetPage { main, error }

class LoginProvider with ChangeNotifier {
  TargetPage _tartgetPage = TargetPage.error;
  TargetPage get targetPage => _tartgetPage;

  UserModel _userModel = UserModel();
  Future<String?> kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        String? email = await checkLogin();
        _tartgetPage = TargetPage.main;
        notifyListeners();
        print('카카오톡으로 로그인 성공');
        return email;
      } catch (error) {
        _tartgetPage = TargetPage.error;
        notifyListeners();
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          String? email = await checkLogin();
          _tartgetPage = TargetPage.main;
          notifyListeners();
          print('카카오계정으로 로그인 성공');
          return email;
        } catch (error) {
          _tartgetPage = TargetPage.error;
          notifyListeners();
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        String? email = await checkLogin();
        _tartgetPage = TargetPage.main;
        notifyListeners();
        print('카카오계정으로 로그인 성공');
        return email;
      } catch (e) {
        _tartgetPage = TargetPage.error;
        notifyListeners();
        print('카카오계정으로 로그인 실패 $e');
      }
    }
  }

  Future<String?> checkLogin() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User user = await UserApi.instance.me();
    var kakaoProfile = user.kakaoAccount!.profile!.nickname;
    var kakaoEmail = user.kakaoAccount!.email;
    var validUser = firestore.collection('회원정보').doc(kakaoProfile).id;
    var name;
    await firestore.collection('회원정보').doc(kakaoProfile).get().then((value) {
      if (value.data() == null) {
        FirebaseFirestore.instance.collection('회원정보').doc(kakaoEmail).set(
            {'pk': user.id, '카카오 프로필': kakaoProfile, '카카오 계정': kakaoEmail});

        name = kakaoProfile;
        return name;
      }
      dynamic user_pk = value.data();
      _userModel = UserModel.fromJson(user_pk);
      // doc 에 동명인이 있을경우
      if (kakaoEmail == validUser) {
        // 동명인이 자기일 경우
        if (user.id == _userModel.pk) {
          name = validUser;

          return name;
        } else {
          FirebaseFirestore.instance.collection('회원정보').doc(kakaoEmail).set({
            'pk': user.id,
            '카카오 프로필': kakaoProfile,
            '카카오 계정': kakaoEmail,
          });
          name = FirebaseFirestore.instance
              .collection('회원정보')
              .doc(kakaoProfile)
              .id;
          return name;
        }
      }
      return null;
    });

    return name;
  }
}

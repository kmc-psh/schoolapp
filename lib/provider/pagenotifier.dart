import 'package:flutter/cupertino.dart';
import 'package:shcoolapp/page/loginpage.dart';


//provider를 사용하여 ChangeNotifier안의 내용이 변할 때 해당 state를 전달해준다.
class PageNotifier extends ChangeNotifier{
  // _ : private값으로 설정해주어 다른 곳에선 접근할 수 없다.
  String _currentPage = LoginPage.pageName;

  // 다른 곳에서 접근할 수 있도록 만들어준다.
  String get currentPage => _currentPage;

  // Main으로 갈 수 있는 function을 만들어준다.
  void goToMain(){
    _currentPage = LoginPage.pageName;
    notifyListeners();
  }
  // (String name): 해당 페이지의 이름을 받아온다.
  void goToOtherPage(String name){
    _currentPage = name;
    notifyListeners();
  }

}
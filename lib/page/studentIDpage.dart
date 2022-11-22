import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/pagenotifier.dart';

class StudentPage extends Page{
  static final String pageName = 'StudentPage';

  // 스튜던트 위젯으로 가는 루트 생성
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => StudentWidget());
  }
}

class StudentWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _StudentWidgetState();

}

class _StudentWidgetState extends State<StudentWidget>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Provider.of<PageNotifier>(context, listen: false)
                .goToOtherPage('AuthPage');
          },

          // 편의상 만든거고 나중에 삭제할 것!!
          icon: Icon(
            Icons.arrow_back,
          ),
          label: Text('')),
        
    ),
    );
  }

}
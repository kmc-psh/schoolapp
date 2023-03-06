import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/controller/kakao_controller.dart';
import 'package:shcoolapp/controller/root_controller.dart';
import 'package:shcoolapp/page/addPostScreen.dart';
import 'package:shcoolapp/page/authpage.dart';
import 'package:shcoolapp/page/boardScreen.dart';
import 'package:shcoolapp/page/calendarpage.dart';
import 'package:shcoolapp/page/chatting_room.dart';
import 'package:shcoolapp/page/chattingpage.dart';
import 'package:shcoolapp/page/kakao_loginScreen.dart';
import 'package:shcoolapp/page/loginpage.dart';
import 'package:shcoolapp/page/mainpage.dart';
import 'package:shcoolapp/page/registScreen.dart';
import 'package:shcoolapp/page/studentIDpage.dart';
import 'package:shcoolapp/page/todolist_page.dart';
import 'package:shcoolapp/provider/board_provider.dart';
import 'package:shcoolapp/provider/chattingProvider.dart';
import 'package:shcoolapp/provider/pagenotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  KakaoSdk.init(nativeAppKey: 'e8ba66760a6c03e65fc4bc3afe5b905f');

  await initializeDateFormatting();
  runApp(MyApp());
}

// 기존
class MyApp extends StatelessWidget {
  //현재 페이지 설정

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: ((context) => ChattingProvider()),
          ),
          ChangeNotifierProvider(create: (context) => LoginProvider())
        ],
        child: const MaterialApp(
            // routes: {'/register': (context) => MainPage()},
            home: KakaoLoginScreen()));
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return GetMaterialApp(
  //     initialBinding: BindingsBuilder(() {
  //       Get.put(RootController());
  //     }),
  //     home: MainPage(),
  //   );
  // }
// }


// ------------------------------------------------------------
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ResgisterScreen(),
//     );
//   }
// }
// ------------------------------------------------------------


//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => PageNotifier())
//       ],
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         debugShowCheckedModeBanner: false,
//         home: Consumer<PageNotifier>(
//           builder: (contex, PageNotifier, child ){
//             return Navigator(
//               pages: [
//                 MaterialPage(
//                     key: ValueKey(LoginPage.pageName),
//                     child: LoginPage()),
//                 //비교연산자 써서 페이지 설정하기,
//                 if (PageNotifier.currentPage == AuthPage.pageName) AuthPage(),
//                 if (PageNotifier.currentPage == StudentPage.pageName) StudentPage(),

//               ],
//               // 뒤로가기 버튼을 눌렀을 때 전 페이지로 가는 과정 route,
//               // 결과값을 받아 전페이지로 전달 result,
//               onPopPage: (route, result) {
//                 if (!route.didPop(result)) {
//                   return false;
//                 }
//                 return true;
//               },
//             );

//           },
//         ),

//       ),
//     );
//   }
// }

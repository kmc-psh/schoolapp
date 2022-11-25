import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shcoolapp/model/user_model.dart';
import 'package:shcoolapp/notifiers/user_notifier.dart';

// class ApiService {

//   static const String API_ENDPOINT = "http://10.0.2.2:3000/user";

//   static getUsers(UserNotifier postNotifier) async {
//     List<UserModel> userList = [];
//     http.get(Uri.parse(API_ENDPOINT)).then((response) {
//       print('Response status: ${response.statusCode}');
//       if (response.statusCode == 200) {
//         print('Response body: ${response.body}');
//       }

//       List users = jsonDecode(response.body);
//       users.forEach((element) {
//         userList.add(UserModel.fromMap(element));
//       });

//       print(userList.length);
//       postNotifier.setPostList(userList);
//     });
//   }

// }

String id = '';
String password = '';

class UserController {
  static const String API_ENDPOINT = "http://10.0.2.2:3000/user";
  addPost(String inputId, String inputPw) async {
    await http.post(
      Uri.parse(API_ENDPOINT),
      headers: <String, String>{
        "Content-type": "application/x-www-form-urlencoded"
      },
      body: <String, String>{
        'id': inputId,
        'password': inputPw,
      },
    );
  }
}

class ImageController {
  static const String API_ENDPOINT = "http://10.0.2.2:3000/image";
  addPost(String img) async {
    await http.post(
      Uri.parse(API_ENDPOINT),
      headers: <String, String>{
        "Content-type": "application/x-www-form-urlencoded"
      },
      body: <String, String>{
        'image': img,
      },
    );
  }
}
// _postRequest() async {
//   http.Response response = await http.post(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/x-www-form-urlencoded',
//     },
//     body: <String, String>{'id': 'kang', 'password': '1235134aaAA!!@@@##'},
//   );
// }

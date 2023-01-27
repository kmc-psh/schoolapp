import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:shcoolapp/model/board_model.dart';

class BoardProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;

  List<BoardModel> _boardModel = [];

  List<BoardModel> get boardModel => _boardModel;
// 데이터 불러오기
  dynamic fetchData() async {
    var result =
        await firestore.collection('board').doc('f5MElAaNOaCEvZ3mKMNl').get();
    print(result);
  }

  void insertData(String id, String title, String content) async {
    try {
      dynamic data = {'title': title, 'content': content};
      firestore.collection('board').doc(id).set(data);
    } catch (e) {
      return null;
    }
  }
}
// 데이터 저장하기

  // void insertData(String location, String content) async {
  //   try {
  //     dynamic data = {'location': location, 'content': content};
  //     String jsonString = jsonEncode(data);
  //     var response = await http.post(Uri.parse(baseUrl),
  //         headers: {"Content-Type": "application/json"}, body: jsonString);
  //     notifyListeners();
  //     print("body:${response.body}");
  //   } catch (e) {
  //     return null;
  //   }
  // }


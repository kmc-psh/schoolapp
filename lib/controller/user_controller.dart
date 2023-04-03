import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/user_model.dart';
import 'kakao_controller.dart';

class UserProvider with ChangeNotifier {
  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  Future fetchUserData(String? email) async {
    var provider = LoginProvider();
    await FirebaseFirestore.instance
        .collection('회원정보')
        .doc(email)
        .get()
        .then((value) {
      dynamic userData = value.data();
      print(value.data());
      _userModel = UserModel.fromJson(userData);
      notifyListeners();
    });
  }

  fetchAllData() async {
    await FirebaseFirestore.instance
        .collection('회원정보')
        .get()
        .then((QuerySnapshot) {
      for (var docSnapshot in QuerySnapshot.docs) {
        // print('${docSnapshot.data()}');
        dynamic userData = docSnapshot.data();
        _userModel = UserModel.fromJson(userData);
        print('######email ${_userModel.email}');
        notifyListeners();
      }
    });
  }
}

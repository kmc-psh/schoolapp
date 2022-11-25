import 'package:flutter/material.dart';
import 'package:shcoolapp/model/user_model.dart';

import '../api/user_api.dart';

class UserNotifier with ChangeNotifier {
  List<UserModel> _userList = [];

  addPostToList(UserModel post) {
    _userList.add(post);
    notifyListeners();
  }

  setPostList(List<UserModel> userList) {
    _userList = [];
    _userList = userList;
    notifyListeners();
  }

  List<UserModel> getPostList() {
    return _userList;
  }

  // Future<bool> uploadPost(UserModel post) async {
  //   return await ApiService.addPost(post, this);
  // }
}

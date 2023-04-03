import 'package:flutter/material.dart';

class UserModel {
  late int pk;
  late String email;
  late String profile;
  String? image;

  UserModel({pk, email, profile, image});

  UserModel.fromJson(Map<String, dynamic> json) {
    pk = json["pk"];
    email = json["카카오 계정"];
    profile = json["카카오 프로필"];
    image = json["프로필 이미지"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pk'] = pk;
    data['카카오 계정'] = email;
    data['카카오 프로필'] = profile;
    data['프로필 이미지'] = image;
    return data;
  }
}

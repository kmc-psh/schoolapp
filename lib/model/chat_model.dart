import 'package:flutter/material.dart';

class ChatModel {
  late String text;

  ChatModel({text});

  ChatModel.fromJson(Map<String, dynamic> json) {
    text = json["text"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    return data;
  }
}

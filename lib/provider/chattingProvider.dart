import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/chatting_model.dart';

class ChattingProvider extends ChangeNotifier {
  static const String CHATTING = 'CHATTING';

  // ChattingProvider(this.pk, this.name);
  // final String pk;
  // final String name;

  var chattingList = <ChattingModel>[];

  Stream getSnapshot() {
    final f = FirebaseFirestore.instance;
    return f
        .collection(CHATTING)
        .limit(1)
        .orderBy('uploadTime', descending: true)
        .snapshots();
  }

  void addOne(ChattingModel model) {
    chattingList.insert(0, model);
    notifyListeners();
  }

  Future load() async {
    var now = DateTime.now().millisecondsSinceEpoch;
    final f = FirebaseFirestore.instance;
    var result = await f
        .collection(CHATTING)
        .where('uploadTime', isGreaterThan: now)
        .orderBy('uploadTime', descending: true)
        .get();
    var l = result.docs.map((e) => ChattingModel.fromJson(e.data())).toList();
    chattingList.addAll(l);
    notifyListeners();
  }

  Future send(String text) async {
    var now = DateTime.now().millisecondsSinceEpoch;
    final f = FirebaseFirestore.instance;
    await f
        .collection(CHATTING)
        .doc(now.toString())
        .set(ChattingModel(text, now).toJson());
  }
}

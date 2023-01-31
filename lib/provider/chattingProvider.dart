import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/chatting_model.dart';

class ChattingProvider extends ChangeNotifier {
  // 파이어 베이스와 연동을 하기위해 만들어줌
  static const String CHATTING = 'CHATTING';

  ChattingProvider();

  // chattingList란 변수를 만들고 ChattingModel.dart에서 가져온다.
  var chattingList = <ChattingModel>[];

  // Snapshot이라는 것은 CHATTING collection의 변화를 트랙킹하고,
  // 변화 된 정보를 가져온다.
  Stream getSnapshot() {
    final f = FirebaseFirestore.instance;
    return f
        .collection(CHATTING)
        .limit(1)
        .orderBy('uploadTime', descending: true)
        .snapshots();
  }

  // 자신이 채팅을 치고 db가 변동이 되었을 때
  // 그것을 반영하여 채팅을 실시간으로 올라오게 하는 기능.
  void addOne(ChattingModel model) {
    chattingList.insert(0, model);
    notifyListeners();
  }

  // 파이어 베이스로 데이터 이동
  // Future = 비동기 처리를 위해 존재, 미래에 요청한 데이터 혹은 에러가 담길 그릇.
  Future load() async {
    var now = DateTime.now().millisecondsSinceEpoch;
    final f = FirebaseFirestore.instance;
    var result = await f
        .collection(CHATTING)
        .where('uploadTime', isGreaterThan: now)
        .orderBy('uploadTime', descending: true)
        .get();
    // ChattingModel에서 받은 제이슨 형식의 데이터를 e.data에 넣어준다.
    var l = result.docs.map((e) => ChattingModel.fromJson(e.data())).toList();
    chattingList.addAll(l);
    // 리스너들에게 변화된 값을 전달(notifyListeners)해준다.
    notifyListeners();
  }

  // 파이어 베이스로 db 보내기
  Future send(String text) async {
    var now = DateTime.now().millisecondsSinceEpoch;
    final f = FirebaseFirestore.instance;
    await f.collection(CHATTING).doc(now.toString()).set(
          ChattingModel(
            text,
            now,
          ).toJson(),
        );
  }
}

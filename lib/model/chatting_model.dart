class ChattingModel {
  // 도큐먼트에 정보 저장
  ChattingModel(
    this.text,
    this.uploadTime,
  );
  final String text;
  final int uploadTime;

  // chattingProvider.dart의
  // var l = result.docs.map((e) => ChattingModel.fromJson(e.data())).toList();
  // chattingList.addAll(l); 부분이 json형식으로 데이터가 들어오기 때문에
  // json형식으로 받아준다.
  factory ChattingModel.fromJson(Map<String, dynamic> json) {
    return ChattingModel(json['text'], json['uploadTime']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'text': text,
      'uploadTime': uploadTime,
    };
  }
}

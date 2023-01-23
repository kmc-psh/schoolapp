class ChattingModel {
  // 도큐먼트에 정보 저장
  ChattingModel(this.text, this.uploadTime);
  final String text;
  final int uploadTime;

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

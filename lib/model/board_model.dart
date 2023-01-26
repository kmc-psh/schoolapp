class BoardModel {
  late String title;
  late String content;
  BoardModel({required this.title, required this.content});
  BoardModel.fromMap(Map<String, dynamic> data) {
    title = data['title'];
    content = data['content'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }

  static fromJson(e) {}
}

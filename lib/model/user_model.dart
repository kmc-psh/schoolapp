class UserModel {
  late int pk;
  late String email;
  late String profile;

  UserModel({pk, email, profile});

  UserModel.fromJson(Map<String, dynamic> json) {
    pk = json["pk"];
    email = json["카카오 계정"];
    profile = json["카카오 프로필"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pk'] = pk;
    data['카카오 프로필'] = email;
    data['profile'] = profile;
    return data;
  }
}

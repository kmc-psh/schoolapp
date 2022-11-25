// class UserModel {
//   late String id;
//   late String password;

//   UserModel({id, password});
//   UserModel.fromjson(Map<String, dynamic> json) {
//     id = json['id'];
//     password = json['password'];
//   }

//   Map<String, dynamic> tojson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['password'] = password;

//     return data;
//   }
// }

class UserModel {
  late String id;
  late String password;
  UserModel({required this.id, required this.password});
  UserModel.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    password = data['password'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'password': password,
    };
  }
}

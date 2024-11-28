class FirebaseTokenModel {
  String? userId;
  String? token;

  FirebaseTokenModel({this.userId, this.token});

  FirebaseTokenModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'token': token,
    };
  }
}
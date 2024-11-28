class UserModel {
  String? userId;
  String? uId;
  String? fullName;
  String? mobileNumber;
  String? email;
  bool? isVerified;
  String? status;
  String? coverImage;
  String? profileImage;
  DateTime? birthDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? password;
  String? address;
  String? userType;
  String? role;

  UserModel({
    this.userId,
    this.uId,
    this.fullName,
    this.mobileNumber,
    this.email,
    this.isVerified,
    this.status,
    this.coverImage,
    this.profileImage,
    this.birthDate,
    this.createdAt,
    this.updatedAt,
    this.password,
    this.address,
    this.userType,
    this.role,
  });

  factory UserModel.fromFormMap(Map<String, dynamic> data) {
    return UserModel(
      uId: data['uId'],
      fullName: data['fullName'],
      mobileNumber: data['mobileNumber'],
      email: data['email'],
      isVerified: data['isVerified'],
      status: data['status'],
      password: data['password'],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['_id'],
      uId: json['uId'],
      fullName: json['fullName'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
      status: json['status'],
      profileImage: json['profileImage'],
      address: json['address'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'email': email,
      'isVerified': isVerified,
      'status': status,
      'password': password,
      'address': address,
      'role': role,
    };
  }
}

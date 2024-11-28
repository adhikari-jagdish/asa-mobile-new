import '../../login/model/userModel.dart';

class ClientReviewsModel {
  String? id;
  double? rating;
  String? reviewMessage;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? customer;

  ClientReviewsModel({
    this.id,
    this.customer,
    this.createdAt,
    this.updatedAt,
    this.reviewMessage,
    this.rating,
  });

  ClientReviewsModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    id = json['_id'];
    rating = json['rating'];
    customer = json['customerId'] != null ? UserModel.fromJson(json['customerId']) : null;
    reviewMessage = json['reviewMessage'];
  }
}

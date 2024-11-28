import 'package:asp_asia/module/destinations/model/destinations_model.dart';
import 'package:asp_asia/module/login/model/userModel.dart';

class NotificationModel {
  String? id;
  UserModel? userId;
  String? customerName;
  String? bookingId;
  DateTime? tripStartDate;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  DestinationsModel? destinationId;
  String? title;

  NotificationModel({
    this.id,
    this.userId,
    this.customerName,
    this.bookingId,
    this.tripStartDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.destinationId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["_id"],
        userId: json["userId"] != null ? UserModel.fromJson(json["userId"]) : null,
        customerName: json["customerName"],
        bookingId: json["bookingId"],
        tripStartDate: json["tripStartDate"] != null ? DateTime.parse(json["tripStartDate"]).toLocal() : null,
        status: json["status"],
        createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]).toLocal() : null,
        updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]).toLocal() : null,
        title: json["title"],
        destinationId: json["destinationId"] != null ? DestinationsModel.fromJson(json["destinationId"]) : null,
      );
}

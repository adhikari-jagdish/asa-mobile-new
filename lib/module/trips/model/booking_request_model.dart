import 'package:intl/intl.dart';

class BookingRequestModel {
  String? id;
  List<String>? destinationIds;
  String? destinationId;
  String? title;
  int? duration;
  String? durationType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fullName;
  String? mealPlan;
  DateTime? tripStartDate;
  int? noOfAdults;
  int? noOfChildren;
  String? mobileNumber;
  String? email;
  int? status;
  String? userId;
  String? image;
  String? hotelStarRating;

  BookingRequestModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.duration,
    this.destinationId,
    this.destinationIds,
    this.fullName,
    this.mealPlan,
    this.mobileNumber,
    this.noOfAdults,
    this.noOfChildren,
    this.tripStartDate,
    this.email,
    this.userId,
    this.status,
    this.image,
    this.durationType,
    this.hotelStarRating,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'duration': duration,
      'destinationId': destinationId,
      'destinationIds': destinationIds,
      'fullName': fullName,
      'mealPlan': mealPlan,
      'mobileNumber': mobileNumber,
      'noOfAdults': noOfAdults,
      'noOfChildren': noOfChildren,
      'tripStartDate': tripStartDate != null
          ? DateFormat('yyyy-MM-dd').format(tripStartDate!)
          : null,
      'email': email,
      'userId': userId,
      'image': image,
      'durationType': durationType,
      'hotelStarRating': hotelStarRating,
    };
  }
}

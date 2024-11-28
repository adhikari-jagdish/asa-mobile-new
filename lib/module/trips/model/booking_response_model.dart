import 'package:asp_asia/module/destinations/model/destinations_model.dart';

class BookingResponseModel {
  String? id;
  List<DestinationsModel>? destinations;
  DestinationsModel? destination;
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

  BookingResponseModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.duration,
    this.destination,
    this.destinations,
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

  BookingResponseModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    id = json['_id'];
    title = json['title'];
    duration = json['duration'];
    fullName = json['fullName'];
    mealPlan = json['mealPlan'];
    mobileNumber = json['mobileNumber'];
    noOfAdults = json['noOfAdults'];
    noOfChildren = json['noOfChildren'];
    tripStartDate = json['tripStartDate'] != null ? DateTime.parse(json['tripStartDate']) : null;
    email = json['email'];
    userId = json['userId'];
    status = json['status'];
    image = json['image'];
    durationType = json['durationType'];
    hotelStarRating = json['hotelStarRating'];
    destination = json['destinationId'] != null ? DestinationsModel.fromJson(json['destinationId']) : null;
    if (json['destinationIds'] != null) {
      destinations = <DestinationsModel>[];
      json['destinationIds'].forEach((v) {
        destinations!.add(DestinationsModel.fromJson(v));
      });
    }
  }
}

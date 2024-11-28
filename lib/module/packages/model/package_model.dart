import 'package:asp_asia/module/hotels/model/hotel_model.dart';

import 'itinerary_model.dart';
import 'package_inclusions_model.dart';
import 'package_rate_model.dart';

class PackageModel {
  String? id;
  List<String>? destinationIds;
  List<String>? travelThemeIds;
  String? destinationId;
  String? travelThemeId;
  String? title;
  int? duration;
  String? durationType;
  String? overview;
  String? image;
  List<PackageInclusionsModel>? packageInclusions;
  List<ItineraryModel>? itinerary;
  List<String>? inclusions;
  List<String>? exclusions;
  List<HotelModel>? hotels;
  List<PackageRateModel>? packageRate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? discountInPercentage;

  PackageModel({
    this.id,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.destinationIds,
    this.title,
    this.duration,
    this.overview,
    this.destinationId,
    this.exclusions,
    this.hotels,
    this.inclusions,
    this.itinerary,
    this.packageInclusions,
    this.packageRate,
    this.travelThemeId,
    this.travelThemeIds,
    this.durationType,
    this.discountInPercentage,
  });

  PackageModel.fromJson(Map<String, dynamic> json) {
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    id = json['_id'];
    image = json['image'];
    destinationIds = json['destinationIds']?.cast<String>();
    title = json['title'];
    duration = json['duration'];
    durationType = json['durationType'];
    overview = json['overview'];
    destinationId = json['destinationId'];
    discountInPercentage = json['discountInPercentage'];
    exclusions = json['exclusions']?.cast<String>();
    if (json['hotels'] != null) {
      hotels = <HotelModel>[];
      json['hotels'].forEach((v) {
        hotels!.add(HotelModel.fromJson(v));
      });
    }
    inclusions = json['inclusions']?.cast<String>();
    if (json['itinerary'] != null) {
      itinerary = <ItineraryModel>[];
      json['itinerary'].forEach((v) {
        itinerary!.add(ItineraryModel.fromJson(v));
      });
    }
    if (json['packageInclusions'] != null) {
      packageInclusions = <PackageInclusionsModel>[];
      json['packageInclusions'].forEach((v) {
        packageInclusions!.add(PackageInclusionsModel.fromJson(v));
      });
    }
    if (json['packageRate'] != null) {
      packageRate = <PackageRateModel>[];
      json['packageRate'].forEach((v) {
        packageRate!.add(PackageRateModel.fromJson(v));
      });
    }
    travelThemeId = json['travelThemeId'];
    travelThemeIds = json['travelThemeIds']?.cast<String>();
  }
}

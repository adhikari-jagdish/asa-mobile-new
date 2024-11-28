import 'package:asp_asia/module/packages/model/package_rate_model.dart';

class HotelModel {
  String? sId;
  String? destinationId;
  String? title;
  String? city;
  double? rating;
  String? overview;
  String? hotelCategory;

  //List<PackageRateModel>? rate;
  String? image;

  HotelModel({
    this.sId,
    this.destinationId,
    this.title,
    this.city,
    this.rating,
    this.overview,
    this.hotelCategory,
    //this.rate,
    this.image,
  });

  HotelModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    destinationId = json['destinationId'];
    title = json['title'];
    image = json['image'];
    city = json['city'];
    rating =
        json['rating'] != null ? json['rating'].toDouble() : json['rating'];
    overview = json['overview'];
    hotelCategory = json['hotelCategory'];
    /*if (json['rate'] != null) {
      rate = <PackageRateModel>[];
      json['rate'].forEach((v) {
        rate!.add(PackageRateModel.fromJson(v));
      });
    }*/
  }
}

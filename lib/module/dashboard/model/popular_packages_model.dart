import 'package:asp_asia/module/packages/model/package_model.dart';

class PopularPackagesModel {
  String? id;
  String? packageId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<PackageModel>? tourPackage;
  List<PackageModel>? trekkingPackage;
  List<PackageModel>? adventurePackage;
  List<PackageModel>? expeditionPackage;
  List<PackageModel>? peakClimbingPackage;

  PopularPackagesModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.adventurePackage,
    this.expeditionPackage,
    this.packageId,
    this.peakClimbingPackage,
    this.tourPackage,
    this.trekkingPackage,
  });

  PopularPackagesModel.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    packageId = json['packageId'];
    createdAt = json['createdAt']!=null? DateTime.parse(json['createdAt']).toLocal() : null;
    updatedAt = json['createdAt']!=null? DateTime.parse(json['createdAt']).toLocal() : null;
    
    if (json['adventurePackage'] != null) {
      adventurePackage = <PackageModel>[];
      json['adventurePackage'].forEach((v) {
        adventurePackage!.add(PackageModel.fromJson(v));
      });
    }
    if (json['expeditionPackage'] != null) {
      expeditionPackage = <PackageModel>[];
      json['expeditionPackage'].forEach((v) {
        expeditionPackage!.add(PackageModel.fromJson(v));
      });
    }
    if (json['peakClimbingPackage'] != null) {
      peakClimbingPackage = <PackageModel>[];
      json['peakClimbingPackage'].forEach((v) {
        peakClimbingPackage!.add(PackageModel.fromJson(v));
      });
    }
    if (json['tourPackage'] != null) {
      tourPackage = <PackageModel>[];
      json['tourPackage'].forEach((v) {
        tourPackage!.add(PackageModel.fromJson(v));
      });
    }
    if (json['trekkingPackage'] != null) {
      trekkingPackage = <PackageModel>[];
      json['trekkingPackage'].forEach((v) {
        trekkingPackage!.add(PackageModel.fromJson(v));
      });
    }
  }
}

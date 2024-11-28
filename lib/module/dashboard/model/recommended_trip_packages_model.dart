import '../../packages/model/package_model.dart';

class RecommendedTripPackagesModel {
  String? id;
  String? packageId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? discountInPercentage;
  List<PackageModel>? tourPackage;
  List<PackageModel>? trekkingPackage;
  List<PackageModel>? adventurePackage;
  List<PackageModel>? expeditionPackage;
  List<PackageModel>? peakClimbingPackage;

  RecommendedTripPackagesModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.adventurePackage,
    this.expeditionPackage,
    this.packageId,
    this.peakClimbingPackage,
    this.tourPackage,
    this.trekkingPackage,
    this.discountInPercentage,
  });

  RecommendedTripPackagesModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    packageId = json['packageId'];
    discountInPercentage = json['discountInPercentage'];
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

// final recommendedTripPackagesList = [
//   RecommendedTripPackagesModel(title: 'Everest Base Camp Trek', duration: '14N/15D', price: 1200, imageUrl: "https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/everest-base-camp-trekking.jpg?alt=media&token=7c443403-2fa5-4b6e-b5b8-b7fa71d7c4e6"),
//   RecommendedTripPackagesModel(title: 'Kathmandu & Pokhara Tour',duration: '04N/05D', price: 450, imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/kathmandu-tour.jpg?alt=media&token=985a665f-5116-4234-b7d2-0e44b055eda9'),
//   RecommendedTripPackagesModel(title: 'Amadablam Expedition',duration: '29N/30D', price: 3500, imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/annapurna_trek.jpg?alt=media&token=e35304f6-6117-4f05-a1d0-e22951072406'),
//   RecommendedTripPackagesModel(title: 'Everest Expedition',duration: '57N/58D', price: 2800, imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/trekking_man.jpg?alt=media&token=8efb26be-66fb-47ae-b691-0d26f898a0a3'),
//   RecommendedTripPackagesModel(title: 'Annapurna Base Camp Trek',duration: '10N/11D', price: 850, imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/nature.jpg?alt=media&token=9e99e3d8-e051-446f-85a4-6570df209782'),
//   RecommendedTripPackagesModel(title: 'Golden Triangle Tour',duration: '06N/07D', price: 220, imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/golden-triangle-tour.jpeg?alt=media&token=e0c1e767-37d4-4a79-a370-fd67ac117ea1'),
//   RecommendedTripPackagesModel(title: 'Honeymoon in Nepal',duration: '05N/06D', price: 189, imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/wild_life_package.jpg?alt=media&token=ba0335c2-91c6-408f-9f7e-fa5b33048d16')
// ];

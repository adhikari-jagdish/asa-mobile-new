class PackageRateModel {
  String? hotelCategory;
  int? rateInNPR;
  int? rateInUSD;
  int? rateInINR;
  int? rateInBDT;
  int? rateInEUR;
  String? id;

  PackageRateModel({
    this.hotelCategory,
    this.rateInNPR,
    this.rateInUSD,
    this.rateInINR,
    this.rateInBDT,
    this.rateInEUR,
    this.id,
  });

  PackageRateModel.fromJson(Map<String, dynamic> json) {
    hotelCategory = json['hotelCategory'];
    rateInNPR = json['rateInNPR'];
    rateInUSD = json['rateInUSD'];
    rateInINR = json['rateInINR'];
    rateInBDT = json['rateInBDT'];
    rateInEUR = json['rateInEUR'];
    id = json['_id'];
  }
}

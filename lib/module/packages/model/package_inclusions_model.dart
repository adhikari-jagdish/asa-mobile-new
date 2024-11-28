class PackageInclusionsModel {
  String? id;
  String? title;
  String? image;

  PackageInclusionsModel({
    this.id,
    this.image,
    this.title,
  });

  PackageInclusionsModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    image = json['image'];
  }
}

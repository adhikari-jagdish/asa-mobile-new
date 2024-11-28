class PackagesByThemeModel {
  String? id;
  String? title;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  PackagesByThemeModel({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.image,
    this.title,
  });

  PackagesByThemeModel.fromJson(Map<String, dynamic> json) {
    createdAt = json["createdAt"] != null ? DateTime.parse(json["createdAt"]).toLocal() : null;
    updatedAt = json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]).toLocal() : null;
    id = json['_id'];
    image = json['image'];
    title = json['title'];
  }
}

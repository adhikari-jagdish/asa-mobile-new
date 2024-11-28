class DestinationsByThemeModel {
  String? id;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  String? title;

  DestinationsByThemeModel({
    this.id,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.title,
  });

  DestinationsByThemeModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['_id'];
    title = json['title'];
    imageUrl = json['imageUrl'];
  }
}
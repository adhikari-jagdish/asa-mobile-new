class CarouselModel {
  String? id;
  String? title;
  String? description;
  String? image;
  int? priority;
  int? screenPlaceType;
  DateTime? createdAt;
  DateTime? updatedAt;

  CarouselModel({
    this.createdAt,
    this.updatedAt,
    this.screenPlaceType,
    this.description,
    this.id,
    this.image,
    this.priority,
    this.title,
  });

  CarouselModel.fromJson(Map<String, dynamic> json) {
    createdAt = json["createdAt"] != null ? DateTime.parse(json["createdAt"]).toLocal() : null;
    updatedAt = json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]).toLocal() : null;
    id = json['_id'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    priority = json['priority'];
    screenPlaceType = json['screenPlaceType'];
  }
}

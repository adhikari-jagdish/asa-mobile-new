class DestinationsModel {
  String? id;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? description;

  DestinationsModel({
    this.id,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.description,
  });

  DestinationsModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['_id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
  }
}

// final destinationsList = [
//   DestinationsModel(destination: 'Nepal', imageUrl: "https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/Honeymoon-in-nepal.jpg?alt=media&token=5396758d-02ce-451f-9fa1-e69f933172eb"),
//   DestinationsModel(destination: 'Bhutan', imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/adventure.jpg?alt=media&token=0c074c4c-3fa3-4600-86a1-4e027649cdf0'),
//   DestinationsModel(destination: 'India', imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/family_tour.jpg?alt=media&token=b46e3a34-8fd2-4939-aa10-7e72ae8d22a2'),
//   DestinationsModel(destination: 'Mt.Kailash', imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/trekking_man.jpg?alt=media&token=8efb26be-66fb-47ae-b691-0d26f898a0a3'),
//   DestinationsModel(destination: 'Tibet', imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/nature.jpg?alt=media&token=9e99e3d8-e051-446f-85a4-6570df209782'),
//   DestinationsModel(destination: 'Thailand', imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/temple_icon.jpg?alt=media&token=a1539f2e-3d11-48bf-93e7-4e4f0e1d6c12'),
//   DestinationsModel(destination: 'SriLanka', imageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/wild_life_package.jpg?alt=media&token=ba0335c2-91c6-408f-9f7e-fa5b33048d16')
// ];

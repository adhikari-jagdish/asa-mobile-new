class TopRatedHotelsModel {
  String? id;
  String? hotelName;
  String? hotelImageUrl;
  double? rating;
  String? hotelLocation;
  DateTime? createdAt;
  DateTime? updatedAt;

  TopRatedHotelsModel({
    this.id,
    this.hotelName,
    this.createdAt,
    this.updatedAt,
    this.hotelImageUrl,
    this.hotelLocation,
    this.rating,
  });

  TopRatedHotelsModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['_id'];
    rating = json['rating'];
    hotelName = json['hotelName'];
    hotelImageUrl = json['hotelImageUrl'];
    hotelLocation = json['hotelLocation'];
  }
}

final topRatedHotelsList = [
  TopRatedHotelsModel(hotelName: 'Hyatt Place', hotelLocation: 'Kathmandu', rating: 5.0, hotelImageUrl: "https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/hyaatpalace.jpg?alt=media&token=4c004b89-8c57-4c0b-a158-3f51aa56c604"),
  TopRatedHotelsModel(hotelName: 'Planet Bhaktapur Hotel', hotelLocation: 'Bhaktapur', rating: 4.2, hotelImageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/planet-bhaktapur.jpg?alt=media&token=c82c9eb8-101a-4d45-99fa-bdb262fb51cc'),
  TopRatedHotelsModel(hotelName: 'Waterfront Resort', hotelLocation: 'Pokhara', rating: 2, hotelImageUrl: 'https://firebasestorage.googleapis.com/v0/b/aspiration-asia.appspot.com/o/waterfrontresort.jpg?alt=media&token=2ac71f9f-b387-4b41-bc94-939d7a9c344a'),
];

class ItineraryModel {
  ItineraryModel({
    this.dayAndTitle,
    this.details,
    this.id,
  });

  String? id;
  String? dayAndTitle;
  List<String>? details;

  ItineraryModel.fromJson(Map<String, dynamic> json) {
    dayAndTitle = json['dayAndTitle'];
    details = json['details']?.cast<String>();
    id = json['_id'];
  }
}

// final itineraries = [
//   ItineraryModel(dayAndTitle: 'Kathmandu Arrival', details: [
//     'Pickup from the airport',
//     'Transfer to the hotel',
//   ]),
//   ItineraryModel(dayAndTitle: 'Kathmandu Sightseeing', details: [
//     'Breakfast',
//     'Half day sightseeing covering Pashupatinath and Bouddhanath',
//     'Transfer back to the hotel',
//     'Overnight at the hotel',
//   ]),
//   ItineraryModel(dayAndTitle: 'Kathmandu Sightseeing', details: [
//     'Breakfast',
//     'Half day sightseeing covering Patan Durbar Square and Swoyambunath',
//     'Transfer back to the hotel',
//     'Overnight at the hotel',
//   ]),
//   ItineraryModel(dayAndTitle: 'Departure', details: [
//     'Breakfast',
//     'Transfer to the airport for final departure',
//   ]),
// ];

import 'package:flutter_bloc/flutter_bloc.dart';

class HotelStarRatingToggleCubit extends Cubit<HotelStarRatingToggleModelForCubit> {
  HotelStarRatingToggleCubit()
      : super(HotelStarRatingToggleModelForCubit(
          index: -1,
          hotelStarRating: '',
        ));
}

class HotelStarRatingToggleModelForCubit {
  int? index;
  String? hotelStarRating;

  HotelStarRatingToggleModelForCubit({
    this.index,
    this.hotelStarRating,
  });
}

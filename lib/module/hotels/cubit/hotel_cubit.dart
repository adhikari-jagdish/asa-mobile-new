import 'package:asp_asia/module/hotels/service/hotel_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/common_strings.dart';
import '../model/hotel_model.dart';

part 'hotel_state.dart';

class HotelCubit extends Cubit<HotelState> {
  HotelCubit({required this.hotelsApiService}) : super(HotelInitial());

  final HotelsApiService hotelsApiService;

  getAllHotels() async {
    emit(HotelLoading());
    try {
      final response = await hotelsApiService.getHotels();
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final hotels = messageAndData.data.map((e) {
        return HotelModel.fromJson(e);
      });
      emit(HotelSuccess(hotels: List<HotelModel>.from(hotels)));
    } catch (e) {
      print(e);
      emit(const HotelError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

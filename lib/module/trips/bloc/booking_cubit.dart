import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:asp_asia/module/trips/service/booking_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_utils/api_utils.dart';
import '../model/booking_request_model.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({required this.bookingApiService}) : super(BookingInitial());

  final BookingApiService bookingApiService;

  void createBooking({required BookingRequestModel bookingModel}) async {
    emit(BookingLoading());
    try {
      final response = await bookingApiService.createBooking(bookingModel);
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndSingleDataFromResponse(response);
      emit(BookingSuccess(successMessage: messageAndData.message));
    } catch (e) {
      emit(const BookingError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

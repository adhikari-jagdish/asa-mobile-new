import 'package:asp_asia/module/dashboard/service/carousel_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../common_utils/api_utils.dart';
import '../../../../common_utils/common_strings.dart';
import '../../model/carousel_model.dart';

part 'carousel_state.dart';

class CarouselCubit extends Cubit<CarouselState> {
  final CarouselApiService carouselApiService;

  CarouselCubit({required this.carouselApiService}) : super(CarouselInitial());

  getAllCarousel() async {
    emit(CarouselLoading());
    try {
      final response = await carouselApiService.getDashboardCarousel();
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final carousels = messageAndData.data.map((e) {
        return CarouselModel.fromJson(e);
      });
      emit(CarouselSuccess(carouselList: List<CarouselModel>.from(carousels)));
    } catch (e) {
      emit(const CarouselError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

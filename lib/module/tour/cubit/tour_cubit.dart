import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/common_strings.dart';
import '../../packages/model/package_model.dart';
import '../service/tour_api_service.dart';

part 'tour_state.dart';

class TourCubit extends Cubit<TourState> {
  TourCubit({required this.tourApiService}) : super(TourInitial());

  final TourApiService tourApiService;

  void getTourPackagesByDestinationId({required String destinationId}) async {
    emit(TourLoading());
    try {
      final response = await tourApiService.getTourPackagesByDestinationId(destinationId);
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final tourPackagesList = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(TourSuccess(tourPackageList: List.from(tourPackagesList)));
    } catch (e) {
      emit(const TourError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }

  void getTourPackagesByTravelThemeId({required String travelThemeId}) async {
    emit(TourLoading());
    try {
      final response = await tourApiService.getTourPackagesByTravelThemeId(travelThemeId);

      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final tourPackagesList = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(TourSuccess(tourPackageList: List.from(tourPackagesList)));
    } catch (e) {
      print(e);
      emit(const TourError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

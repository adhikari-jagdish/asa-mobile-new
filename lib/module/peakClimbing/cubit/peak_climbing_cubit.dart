import 'package:asp_asia/module/peakClimbing/service/peak_climbing_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/common_strings.dart';
import '../../packages/model/package_model.dart';

part 'peak_climbing_state.dart';

class PeakClimbingCubit extends Cubit<PeakClimbingState> {
  PeakClimbingCubit({required this.peakClimbingApiService}) : super(PeakClimbingInitial());

  final PeakClimbingApiService peakClimbingApiService;

  void getPeakClimbingPackagesByDestinationId({required String destinationId}) async {
    emit(PeakClimbingLoading());
    try {
      final response = await peakClimbingApiService.getPeakClimbingPackagesByDestinationId(destinationId);
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final peakClimbingList = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(PeakClimbingSuccess(peakClimbingList: List.from(peakClimbingList)));
    } catch (e) {
      emit(const PeakClimbingError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }

  void getPeakClimbingPackagesByTravelThemeId({required String travelThemeId}) async {
    emit(PeakClimbingLoading());
    try {
      final response = await peakClimbingApiService.getPeakClimbingPackagesByTravelThemeId(travelThemeId);
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final peakClimbingList = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(PeakClimbingSuccess(peakClimbingList: List.from(peakClimbingList)));
    } catch (e) {
      emit(const PeakClimbingError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

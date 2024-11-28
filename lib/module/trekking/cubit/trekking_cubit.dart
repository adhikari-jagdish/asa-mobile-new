import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_utils/api_utils.dart';
import '../../packages/model/package_model.dart';
import '../service/trekking_api_service.dart';

part 'trekking_state.dart';

class TrekkingCubit extends Cubit<TrekkingState> {
  TrekkingCubit({required this.trekkingApiService}) : super(TrekkingInitial());

  final TrekkingApiService trekkingApiService;

  void getTrekkingPackagesByDestinationId({required String destinationId}) async {
    emit(TrekkingLoading());
    try {
      final response = await trekkingApiService.getTrekkingPackagesByDestinationId(destinationId);
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final trekkingList = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(TrekkingSuccess(trekkingPackageList: List.from(trekkingList)));
    } catch (e) {
      emit(const TrekkingError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }

  void getTrekkingPackagesByTravelThemeId({required String travelThemeId}) async {
    emit(TrekkingLoading());
    try {
      final response = await trekkingApiService.getTrekkingPackagesByTravelThemeId(travelThemeId);
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final trekkingList = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(TrekkingSuccess(trekkingPackageList: List.from(trekkingList)));
    } catch (e) {
      emit(const TrekkingError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

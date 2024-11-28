import 'package:asp_asia/module/expedition/service/expedition_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/common_strings.dart';
import '../../packages/model/package_model.dart';

part 'expedition_state.dart';

class ExpeditionCubit extends Cubit<ExpeditionState> {
  ExpeditionCubit({required this.expeditionApiService}) : super(ExpeditionInitial());

  final ExpeditionApiService expeditionApiService;

  void getExpeditionPackagesByDestinationId({required String destinationId}) async {
    emit(ExpeditionLoading());
    try {
      final response = await expeditionApiService.getExpeditionPackagesByDestinationId(destinationId);
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final expeditionList = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(ExpeditionSuccess(expeditionPackageList: List.from(expeditionList)));
    } catch (e) {
      print('Error in Exedition $e');
      emit(const ExpeditionError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }

  void getExpeditionPackagesByTravelThemeId({required String travelThemeId}) async {
    emit(ExpeditionLoading());
    try {
      final response = await expeditionApiService.getExpeditionPackagesByTravelThemeId(travelThemeId);
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final expeditionList = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(ExpeditionSuccess(expeditionPackageList: List.from(expeditionList)));
    } catch (e) {
      emit(const ExpeditionError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

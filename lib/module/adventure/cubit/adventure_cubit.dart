import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/common_strings.dart';
import '../../packages/model/package_model.dart';
import '../service/adventure_api_service.dart';

part 'adventure_state.dart';

class AdventureCubit extends Cubit<AdventureState> {
  AdventureCubit({required this.adventureApiService})
      : super(AdventureInitial());

  final AdventureApiService adventureApiService;

  void getAdventurePackagesByDestinationId(
      {required String destinationId}) async {
    print('Adventure Service Called');
    emit(AdventureLoading());
    try {
      final response = await adventureApiService
          .getAdventurePackagesByDestinationId(destinationId);
      print('Adventure Response ${response.statusCode}');
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData =
          ApiUtils.getMessageAndMultiDataFromResponse(response);
      final tourPackagesList = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(AdventureSuccess(adventurePackages: List.from(tourPackagesList)));
    } catch (e) {
      print('Adventure Error $e');
      emit(const AdventureError(
          errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }

  void getAdventurePackagesByTravelThemeId(
      {required String travelThemeId}) async {
    emit(AdventureLoading());
    print('Travel theme id $travelThemeId');
    try {
      final response = await adventureApiService
          .getAdventurePackagesByTravelThemeId(travelThemeId);
      print('Adventure Response ${response.statusCode}');
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData =
          ApiUtils.getMessageAndMultiDataFromResponse(response);

      final tourPackagesList = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(AdventureSuccess(adventurePackages: List.from(tourPackagesList)));
    } catch (e) {
      print(e);
      emit(const AdventureError(
          errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

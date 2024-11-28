import 'package:asp_asia/module/dashboard/model/recommended_trip_packages_model.dart';
import 'package:asp_asia/module/dashboard/service/recommended_package_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../common_utils/api_utils.dart';
import '../../../../common_utils/common_strings.dart';
import '../../../packages/model/package_model.dart';

part 'recommended_package_state.dart';

class RecommendedPackageCubit extends Cubit<RecommendedPackageState> {
  RecommendedPackageCubit({required this.recommendedPackageApiService}) : super(RecommendedPackageInitial());

  final RecommendedPackageApiService recommendedPackageApiService;

  getAllRecommendedPackages() async {

    emit(RecommendedPackageLoading());
    try {
      final response = await recommendedPackageApiService.getRecommendedPackages();
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final recommendedPackagesList = messageAndData.data.map((e) {
        return RecommendedTripPackagesModel.fromJson(e);
      });

      List<PackageModel> mergedPopularPackages = [];
      if (recommendedPackagesList.isNotEmpty) {

        for (var recommendedPackage in recommendedPackagesList) {
          List<PackageModel> tempMergedPackages = [];
          tempMergedPackages = [
            ...recommendedPackage.adventurePackage ?? [],
            ...recommendedPackage.expeditionPackage ?? [],
            ...recommendedPackage.tourPackage ?? [],
            ...recommendedPackage.peakClimbingPackage ?? [],
            ...recommendedPackage.trekkingPackage ?? [],
          ];
          mergedPopularPackages.addAll(tempMergedPackages);
        }
      }
      print('Recommended final ${mergedPopularPackages.length}');
      emit(RecommendedPackageSuccess(recommendedPackages: mergedPopularPackages));
    } catch (e) {
      print(e);
      emit(const RecommendedPackageError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

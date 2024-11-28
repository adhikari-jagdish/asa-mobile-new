import 'package:asp_asia/module/dashboard/service/popular_package_api_service.dart';
import 'package:asp_asia/module/packages/model/package_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../common_utils/api_utils.dart';
import '../../../../common_utils/common_strings.dart';
import '../../model/popular_packages_model.dart';

part 'popular_packages_state.dart';

class PopularPackagesCubit extends Cubit<PopularPackagesState> {
  PopularPackagesCubit({required this.popularPackageApiService}) : super(PopularPackagesInitial());

  final PopularPackageApiService popularPackageApiService;

  getAllPopularPackages() async {
    emit(PopularPackagesLoading());
    try {
      final response = await popularPackageApiService.getPopularPackages();
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final popularPackagesList = messageAndData.data.map((e) {
        return PopularPackagesModel.fromJson(e);
      });

      List<PackageModel> mergedPopularPackages = [];
      if (popularPackagesList.isNotEmpty) {
        for (var popularPackage in popularPackagesList) {
          List<PackageModel> tempMergedPackages = [];
          tempMergedPackages = [
            ...popularPackage.adventurePackage ?? [],
            ...popularPackage.expeditionPackage ?? [],
            ...popularPackage.tourPackage ?? [],
            ...popularPackage.peakClimbingPackage ?? [],
            ...popularPackage.trekkingPackage ?? [],
          ];
          mergedPopularPackages.addAll(tempMergedPackages);
        }
      }
      emit(PopularPackagesSuccess(popularPackages: mergedPopularPackages));
    } catch (e) {
      print(e);
      emit(const PopularPackagesError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

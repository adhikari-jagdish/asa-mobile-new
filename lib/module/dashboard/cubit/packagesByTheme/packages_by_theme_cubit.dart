import 'package:asp_asia/module/dashboard/model/packages_by_theme_model.dart';
import 'package:asp_asia/module/dashboard/service/packages_by_theme_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../common_utils/api_utils.dart';
import '../../../../common_utils/common_strings.dart';

part 'packages_by_theme_state.dart';

class PackagesByThemeCubit extends Cubit<PackagesByThemeState> {
  PackagesByThemeCubit({required this.packagesByThemeApiService}) : super(PackagesByThemeInitial());

  final PackagesByThemeApiService packagesByThemeApiService;

  getAllPackagesByTheme() async {
    emit(PackagesByThemeLoading());
    try {
      final response = await packagesByThemeApiService.getPackagesByTheme();
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final packagesByThemeList = messageAndData.data.map((e) {
        return PackagesByThemeModel.fromJson(e);
      });
      emit(PackagesByThemeSuccess(packagesByThemeList: List.from(packagesByThemeList)));
    } catch (e) {
      emit(const PackagesByThemeError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

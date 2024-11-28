import 'package:asp_asia/module/search/service/package_search_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/common_strings.dart';
import '../../packages/model/package_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.packageSearchApiService}) : super(SearchInitial());

  final PackageSearchApiService packageSearchApiService;

  searchPackages({required String searchText}) async {
    emit(SearchLoading());
    try {
      final response = await packageSearchApiService.searchPackage(searchText: searchText);
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final packages = messageAndData.data.map((e) {
        return PackageModel.fromJson(e);
      });
      emit(SearchSuccess(packages: List<PackageModel>.from(packages)));
    } catch (e) {
      print(e);
      emit(const SearchError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

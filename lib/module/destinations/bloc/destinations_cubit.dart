import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/common_strings.dart';
import '../model/destinations_model.dart';
import '../service/destinations_service.dart';

part 'destinations_state.dart';

class DestinationsCubit extends Cubit<DestinationsState> {
  DestinationsCubit({required this.destinationApiService}) : super(DestinationsInitial());

  final DestinationApiService destinationApiService;

  getAllDestinations() async {
    emit(DestinationsLoading());
    try {
      final response = await destinationApiService.getDestinations();
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final destinations = messageAndData.data.map((e) {
        return DestinationsModel.fromJson(e);
      });
      emit(DestinationsSuccess(destinationsList: List<DestinationsModel>.from(destinations)));
    } catch (e) {
      print(e);
      emit(const DestinationsError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }

}



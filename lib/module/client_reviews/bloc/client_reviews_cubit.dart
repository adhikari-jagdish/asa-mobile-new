import 'package:asp_asia/module/client_reviews/service/client_reviews_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/common_strings.dart';
import '../model/client_reviews_model.dart';

part 'client_reviews_state.dart';

class ClientReviewsCubit extends Cubit<ClientReviewsState> {
  ClientReviewsCubit({required this.clientReviewsService}) : super(ClientReviewsInitial());

  final ClientReviewsService clientReviewsService;

  void getClientReviews() async {
    emit(ClientReviewsLoading());
    try {
      final response = await clientReviewsService.getClientReviews();
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndMultiDataFromResponse(response);
      final clientReviews = messageAndData.data.map((e) {
        return ClientReviewsModel.fromJson(e);
      });
      emit(ClientReviewsSuccess(clientReviews: List<ClientReviewsModel>.from(clientReviews)));
    } catch (e) {
      emit(const ClientReviewsError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}

part of 'client_reviews_cubit.dart';

abstract class ClientReviewsState extends Equatable {
  const ClientReviewsState();
}

class ClientReviewsInitial extends ClientReviewsState {
  @override
  List<Object> get props => [];
}

class ClientReviewsLoading extends ClientReviewsState {
  @override
  List<Object> get props => [];
}

class ClientReviewsSuccess extends ClientReviewsState {

  const ClientReviewsSuccess({required this.clientReviews});

  final List<ClientReviewsModel> clientReviews;

  @override
  List<Object> get props => [clientReviews];
}

class ClientReviewsError extends ClientReviewsState {

  const ClientReviewsError({required this.errorMessage});

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

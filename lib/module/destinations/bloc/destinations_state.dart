part of 'destinations_cubit.dart';

abstract class DestinationsState extends Equatable {
  const DestinationsState();
}

class DestinationsInitial extends DestinationsState {
  @override
  List<Object> get props => [];
}

class DestinationsLoading extends DestinationsState {
  @override
  List<Object> get props => [];
}

class DestinationsSuccess extends DestinationsState {
  const DestinationsSuccess({required this.destinationsList});

  final List<DestinationsModel> destinationsList;

  @override
  List<Object> get props => [destinationsList];
}

class DestinationsError extends DestinationsState {
  const DestinationsError({this.errorMessage});

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

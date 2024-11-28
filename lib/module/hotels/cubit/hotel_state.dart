part of 'hotel_cubit.dart';

abstract class HotelState extends Equatable {
  const HotelState();
}

class HotelInitial extends HotelState {
  @override
  List<Object> get props => [];
}

class HotelLoading extends HotelState {
  @override
  List<Object> get props => [];
}

class HotelSuccess extends HotelState {
  const HotelSuccess({required this.hotels});

  final List<HotelModel> hotels;

  @override
  List<Object> get props => [hotels];
}

class HotelError extends HotelState {
  const HotelError({required this.errorMessage});

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

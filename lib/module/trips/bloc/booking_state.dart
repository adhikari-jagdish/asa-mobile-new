part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();
}

class BookingInitial extends BookingState {
  @override
  List<Object> get props => [];
}

class BookingLoading extends BookingState {
  @override
  List<Object> get props => [];
}

class BookingSuccess extends BookingState {
  const BookingSuccess({this.bookingList, this.successMessage});

  final List<BookingRequestModel>? bookingList;
  final String? successMessage;

  @override
  List<Object?> get props => [bookingList, successMessage];
}

class BookingError extends BookingState {
  const BookingError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

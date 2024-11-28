part of 'tour_cubit.dart';

abstract class TourState extends Equatable {
  const TourState();
}

class TourInitial extends TourState {
  @override
  List<Object> get props => [];
}

class TourLoading extends TourState {
  @override
  List<Object> get props => [];
}

class TourSuccess extends TourState {
  const TourSuccess({required this.tourPackageList});

  final List<PackageModel> tourPackageList;

  @override
  List<Object> get props => [tourPackageList];
}

class TourError extends TourState {
  const TourError({required this.errorMessage});

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

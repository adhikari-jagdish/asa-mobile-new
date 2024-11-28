part of 'peak_climbing_cubit.dart';

abstract class PeakClimbingState extends Equatable {
  const PeakClimbingState();
}

class PeakClimbingInitial extends PeakClimbingState {
  @override
  List<Object> get props => [];
}

class PeakClimbingLoading extends PeakClimbingState {
  @override
  List<Object> get props => [];
}

class PeakClimbingSuccess extends PeakClimbingState {
  const PeakClimbingSuccess({required this.peakClimbingList});

  final List<PackageModel> peakClimbingList;

  @override
  List<Object> get props => [peakClimbingList];
}

class PeakClimbingError extends PeakClimbingState {
  const PeakClimbingError({this.errorMessage});

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

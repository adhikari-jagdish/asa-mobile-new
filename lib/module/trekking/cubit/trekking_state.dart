part of 'trekking_cubit.dart';

abstract class TrekkingState extends Equatable {
  const TrekkingState();
}

class TrekkingInitial extends TrekkingState {
  @override
  List<Object> get props => [];
}

class TrekkingLoading extends TrekkingState {
  @override
  List<Object> get props => [];
}

class TrekkingSuccess extends TrekkingState {
  const TrekkingSuccess({required this.trekkingPackageList});

  final List<PackageModel> trekkingPackageList;

  @override
  List<Object> get props => [trekkingPackageList];
}

class TrekkingError extends TrekkingState {
  const TrekkingError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

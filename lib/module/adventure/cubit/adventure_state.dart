part of 'adventure_cubit.dart';

abstract class AdventureState extends Equatable {
  const AdventureState();
}

class AdventureInitial extends AdventureState {
  @override
  List<Object> get props => [];
}

class AdventureLoading extends AdventureState {
  @override
  List<Object> get props => [];
}

class AdventureSuccess extends AdventureState {
  const AdventureSuccess({required this.adventurePackages});

  final List<PackageModel> adventurePackages;

  @override
  List<Object> get props => [adventurePackages];
}

class AdventureError extends AdventureState {
  const AdventureError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

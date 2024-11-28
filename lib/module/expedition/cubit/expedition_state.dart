part of 'expedition_cubit.dart';

abstract class ExpeditionState extends Equatable {
  const ExpeditionState();
}

class ExpeditionInitial extends ExpeditionState {
  @override
  List<Object> get props => [];
}

class ExpeditionLoading extends ExpeditionState {
  @override
  List<Object> get props => [];
}

class ExpeditionSuccess extends ExpeditionState {

  const ExpeditionSuccess({required this.expeditionPackageList});

  final List<PackageModel> expeditionPackageList;

  @override
  List<Object> get props => [expeditionPackageList];
}

class ExpeditionError extends ExpeditionState {

  const ExpeditionError({required this.errorMessage});

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

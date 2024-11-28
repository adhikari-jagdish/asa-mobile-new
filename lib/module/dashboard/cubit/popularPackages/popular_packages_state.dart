part of 'popular_packages_cubit.dart';

abstract class PopularPackagesState extends Equatable {
  const PopularPackagesState();
}

class PopularPackagesInitial extends PopularPackagesState {
  @override
  List<Object> get props => [];
}

class PopularPackagesLoading extends PopularPackagesState {
  @override
  List<Object> get props => [];
}

class PopularPackagesSuccess extends PopularPackagesState {

  const PopularPackagesSuccess({required this.popularPackages});

  final List<PackageModel> popularPackages;

  @override
  List<Object> get props => [popularPackages];
}

class PopularPackagesError extends PopularPackagesState {
  const PopularPackagesError({required this.errorMessage});

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

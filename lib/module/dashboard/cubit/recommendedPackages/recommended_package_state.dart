part of 'recommended_package_cubit.dart';

abstract class RecommendedPackageState extends Equatable {
  const RecommendedPackageState();
}

class RecommendedPackageInitial extends RecommendedPackageState {
  @override
  List<Object> get props => [];
}

class RecommendedPackageLoading extends RecommendedPackageState {
  @override
  List<Object> get props => [];
}

class RecommendedPackageSuccess extends RecommendedPackageState {
  const RecommendedPackageSuccess({required this.recommendedPackages});

  @override
  List<Object?> get props => [recommendedPackages];

  final List<PackageModel> recommendedPackages;
}

class RecommendedPackageError extends RecommendedPackageState {
  const RecommendedPackageError({required this.errorMessage});

  final String? errorMessage;

  @override
  List<Object?> get props => [];
}

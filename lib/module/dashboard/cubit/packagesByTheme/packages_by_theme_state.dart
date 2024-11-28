part of 'packages_by_theme_cubit.dart';

abstract class PackagesByThemeState extends Equatable {
  const PackagesByThemeState();
}

class PackagesByThemeInitial extends PackagesByThemeState {
  @override
  List<Object> get props => [];
}

class PackagesByThemeLoading extends PackagesByThemeState {
  @override
  List<Object> get props => [];
}

class PackagesByThemeSuccess extends PackagesByThemeState {
  final List<PackagesByThemeModel> packagesByThemeList;

  const PackagesByThemeSuccess({required this.packagesByThemeList});

  @override
  List<Object> get props => [packagesByThemeList];
}

class PackagesByThemeError extends PackagesByThemeState {
  final String? errorMessage;

  const PackagesByThemeError({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

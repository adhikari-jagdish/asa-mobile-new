part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchSuccess extends SearchState {
  const SearchSuccess({required this.packages});

  final List<PackageModel> packages;

  @override
  List<Object> get props => [packages];
}

class SearchError extends SearchState {
  const SearchError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

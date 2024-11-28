part of 'carousel_cubit.dart';

abstract class CarouselState extends Equatable {
  const CarouselState();
}

class CarouselInitial extends CarouselState {
  @override
  List<Object> get props => [];
}

class CarouselLoading extends CarouselState {
  @override
  List<Object> get props => [];
}

class CarouselSuccess extends CarouselState {
  final List<CarouselModel> carouselList;

  const CarouselSuccess({required this.carouselList});

  @override
  List<Object> get props => [carouselList];
}

class CarouselError extends CarouselState {
  final String errorMessage;

  const CarouselError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserSuccess extends UserState {
  @override
  List<Object?> get props => [
        successMessage,
        isImageUpdate,
      ];

  const UserSuccess({
    this.successMessage,
    this.isImageUpdate = false,
    this.context,
  });

  final String? successMessage;
  final bool? isImageUpdate;
  final BuildContext? context;
}

class UserError extends UserState {
  @override
  List<Object?> get props => [errorMessage];

  const UserError({this.errorMessage});

  final String? errorMessage;
}

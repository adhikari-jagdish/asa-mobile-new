import 'package:flutter_bloc/flutter_bloc.dart';

class MonthOfTravelToggleCubit extends Cubit<MonthOfTravelToggleModelForCubit> {
  MonthOfTravelToggleCubit()
      : super(MonthOfTravelToggleModelForCubit(
          index: -1,
          monthOfTravel: '',
        ));
}

class MonthOfTravelToggleModelForCubit {
  int? index;
  String? monthOfTravel;

  MonthOfTravelToggleModelForCubit({
    this.index,
    this.monthOfTravel,
  });
}

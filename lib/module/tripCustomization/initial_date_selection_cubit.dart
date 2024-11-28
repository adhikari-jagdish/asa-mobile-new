import 'package:flutter_bloc/flutter_bloc.dart';

class InitialDateSelectionCubit extends Cubit<DateTime> {
  InitialDateSelectionCubit()
      : super(DateTime.now().add(const Duration(days: 1)));
}

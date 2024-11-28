import 'package:asp_asia/common_utils/custom_sized_box.dart';
import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:asp_asia/theme/custom_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../module/packages/bloc/month_of_travel_toggle_cubit.dart';
import '../../module/tripCustomization/initial_date_selection_cubit.dart';

class MonthOfTravelDialogWithSingleSelection extends StatelessWidget {
  const MonthOfTravelDialogWithSingleSelection({
    Key? key,
    required this.monthOfTravelOptions,
  }) : super(key: key);

  final List<String> monthOfTravelOptions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 500.h,
            child: CupertinoScrollbar(
              thumbVisibility: true,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: monthOfTravelOptions.length,
                itemBuilder: (context, index) {
                  final option = monthOfTravelOptions[index];
                  return Wrap(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.7,
                        child: Text(option),
                      ),
                      FractionallySizedBox(
                        child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: BlocBuilder<MonthOfTravelToggleCubit,
                              MonthOfTravelToggleModelForCubit>(
                            builder: (context, monthOfTravelModel) {
                              return Checkbox(
                                  shape: const CircleBorder(),
                                  value: index == monthOfTravelModel.index
                                      ? true
                                      : false,
                                  onChanged: (val) {
                                    context
                                        .read<MonthOfTravelToggleCubit>()
                                        .emit(
                                      MonthOfTravelToggleModelForCubit(
                                        index: index ==
                                            monthOfTravelModel
                                                .index &&
                                            !val!
                                            ? monthOfTravelModel.index
                                            : index,
                                        monthOfTravel: option,
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      const Divider(),
                      sboxH5,
                    ],
                  );
                },
              ),
            ),
          ),
          const Divider(),
          sboxH30,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'OK',
                style: CustomStyle.blackTextSemiBold
                    .copyWith(color: Colors.teal, fontSize: 14.sp),
              ).clickable(() {
                if (context
                    .read<MonthOfTravelToggleCubit>()
                    .state
                    .monthOfTravel != null) {
                  DateFormat format = DateFormat("MMM yyyy");
                  context.read<InitialDateSelectionCubit>().emit(
                      format.parse(context
                          .read<MonthOfTravelToggleCubit>()
                          .state
                          .monthOfTravel!));
                }
                Navigator.of(context).pop();
              }),
            ],
          )
        ],
      ),
    );
  }
}

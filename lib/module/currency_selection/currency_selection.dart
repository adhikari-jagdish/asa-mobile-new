import 'package:asp_asia/assets/assets.dart';
import 'package:asp_asia/common_utils/view_utils/shared_preference_master.dart';
import 'package:asp_asia/routes/route_constants.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sized_context/sized_context.dart';

import '../../common_utils/common_strings.dart';
import '../../common_utils/custom_sized_box.dart';
import '../../common_utils/system_util.dart';
import '../../theme/custom_color.dart';
import '../../theme/custom_style.dart';
import 'cubit/currency_selection_cubit.dart';

class CurrencySelection extends StatefulWidget {
  const CurrencySelection({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CurrencySelectionState();
}

class _CurrencySelectionState extends State<CurrencySelection> {
  final _currencyCodes = ['NPR', 'USD', 'EUR', 'INR', 'BDT'];

  @override
  void initState() {
    super.initState();
    SystemUtils().showSystemUiOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:
              EdgeInsets.only(left: 25.w, top: 20.h, right: 25.w, bottom: 20.h),
          height: context.heightPx,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CommonStrings.welcome,
                style: CustomStyle.blackTextBold.copyWith(fontSize: 25.sp),
              ),
              sboxH3,
              Text(
                CommonStrings.selectPreferredCurrency,
                style: CustomStyle.blackTextRegular.copyWith(
                  color: Colors.grey[700],
                  fontSize: 20.sp,
                ),
              ),
              /*sboxH10,
              Text(
                CommonStrings.noteRegardingCurrency,
                style: CustomStyle.blackTextRegular.copyWith(
                    color: Colors.grey,
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic),
              ),*/
              sboxH30,
              BlocBuilder<CurrencySelectionCubit, int>(
                  builder: (context, updatedSelectionPosition) {
                return SizedBox(
                  height: context.heightPx - 240.h,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    children: List.generate(
                      _currencyCodes.length,
                      (index) => _currencyDivisionBoxes(
                          index,
                          updatedSelectionPosition == index
                              ? CustomColor.color2a8dc8
                              : Colors.white),
                    ),
                  ),
                );
              }),
              sboxH20,
              BlocBuilder<CurrencySelectionCubit, int>(
                  builder: (context, currencySelectionUpdateIndex) {
                return SizedBox(
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: currencySelectionUpdateIndex != -1
                        ? () {
                            BotToast.showLoading();
                            RepositoryProvider.of<SharedPreferenceMaster>(
                                    context)
                                .currencySelected
                                .setValue(_currencyCodes[
                                    currencySelectionUpdateIndex]);
                            RepositoryProvider.of<SharedPreferenceMaster>(
                                    context)
                                .isCurrencySelected
                                .setValue(true);
                            Future.delayed(
                              const Duration(seconds: 2),
                              () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteConstants.routeDashboardBottomNav,
                                  (route) {
                                    return false;
                                  },
                                );
                                BotToast.closeAllLoading();
                              },
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      padding: const EdgeInsets.all(0.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: currencySelectionUpdateIndex != -1
                            ? CustomColor.color2a8dc8
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: context.widthPx, minHeight: 40.h),
                        alignment: Alignment.center,
                        child: Text(
                          CommonStrings.textContinue,
                          textAlign: TextAlign.center,
                          style: CustomStyle.whiteTextSemiBold
                              .copyWith(fontSize: 18.sp),
                        ),
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  _currencyDivisionBoxes(int index, Color borderColor) {
    const currencyArray = [
      'Nepali Rupees',
      'US Dollar',
      'Euro',
      'Indian Rupees',
      'Bangladesh Taka',
    ];
    final flagArray = [
      Assets.nepalFlagIcon,
      Assets.usDollarIcon,
      Assets.euroIcon,
      Assets.indiaFlagIcon,
      Assets.bangladeshFlagIcon,
    ];
    return GestureDetector(
      onTap: () => BlocProvider.of<CurrencySelectionCubit>(context).emit(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: borderColor),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: Column(
            children: [
              SvgPicture.asset(
                flagArray[index],
                width: 40.w,
                height: 40.h,
              ),
              sboxH30,
              Text(
                currencyArray[index],
                style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 20.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:asp_asia/common_utils/view_utils/app_loader_widget.dart';
import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:asp_asia/module/packages/model/package_model.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mmoo_country_pickers/country.dart';
import 'package:mmoo_country_pickers/country_picker_dropdown.dart';
import 'package:mmoo_country_pickers/utils/utils.dart';
import 'package:sized_context/sized_context.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../packages/bloc/country_code_update_cubit.dart';
import '../packages/bloc/hotel_star_rating_toggle_cubit.dart';
import '../trips/bloc/booking_cubit.dart';
import '../trips/model/booking_request_model.dart';
import '../../routes/route_constants.dart';
import '../../theme/custom_style.dart';
import '../../common_utils/custom_sized_box.dart';
import '../../common_utils/view_utils/custom_button.dart';
import '../../common_utils/view_utils/custom_cupertino_alert_dialog.dart';
import '../../common_utils/view_utils/shared_preference_master.dart';
import 'initial_date_selection_cubit.dart';

class TripCustomization extends StatefulWidget {
  const TripCustomization({
    Key? key,
    required this.packageModel,
  }) : super(key: key);

  final PackageModel? packageModel;

  @override
  State<TripCustomization> createState() => _TripCustomizationState();
}

class _TripCustomizationState extends State<TripCustomization> {
  final mealPlanOptions = [
    'CP (Breakfast)',
    'MAP (Breakfast & Dinner)',
    'AP (Breakfast, Lunch & Dinner)'
  ];
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ).clickable(() {
          Navigator.of(context).pop();
        }),
      ),
      body: BlocListener<BookingCubit, BookingState>(
        listener: (context, bookingState) {
          if (bookingState is BookingLoading) {
            showAppLoader();
          } else if (bookingState is BookingSuccess) {
            BotToast.showText(text: CommonStrings.bookingPlacedSuccessfully);
            closeAppLoader();
            Navigator.of(context).pop();
          } else if (bookingState is BookingError) {
            closeAppLoader();
            BotToast.showText(text: bookingState.errorMessage);
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: ScrollController(),
          child: FormBuilder(
            key: _formKey,
            child: Container(
              width: context.widthPx,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilderDropdown(
                    name: 'mealPlan',
                    decoration: InputDecoration(
                      hintText: 'Select Meal Plan',
                      suffix: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _formKey.currentState!.fields['mealPlan']?.reset();
                        },
                      ),
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: mealPlanOptions
                        .map((mealPlan) => DropdownMenuItem(
                              value: mealPlan,
                              child: Text(mealPlan,
                                  style: CustomStyle.blackTextRegular.copyWith(
                                    fontSize: 13.sp,
                                  )),
                            ))
                        .toList(),
                  ),
                  sboxH20,
                  FormBuilderTextField(
                    name: 'fullName',
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: CustomStyle.blackTextRegular
                          .copyWith(fontSize: 13.sp),
                      suffixIcon: const Icon(Icons.person),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(70),
                    ]),
                    keyboardType: TextInputType.text,
                  ),
                  sboxH20,
                  FormBuilderDateTimePicker(
                    name: 'tripStartDate',
                    inputType: InputType.date,
                    initialDate:
                        context.read<InitialDateSelectionCubit>().state,
                    firstDate: DateTime.now().add(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 364)),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    decoration: InputDecoration(
                      labelText: 'Trip Start Date',
                      labelStyle: CustomStyle.blackTextRegular
                          .copyWith(fontSize: 13.sp),
                      suffixIcon: const Icon(Icons.calendar_month),
                    ),
                    // enabled: true,
                  ),
                  sboxH20,
                  FormBuilderTextField(
                    name: 'noOfAdults',
                    decoration: InputDecoration(
                      counter: const Offstage(),
                      labelText: 'No of Adults',
                      labelStyle: CustomStyle.blackTextRegular
                          .copyWith(fontSize: 13.sp),
                      suffixIcon: const Icon(Icons.people),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.max(100),
                    ]),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    valueTransformer: (val) {
                      if (val != null) {
                        return int.parse(val);
                      }
                    },
                  ),
                  sboxH20,
                  FormBuilderTextField(
                    name: 'noOfChildren',
                    decoration: InputDecoration(
                      counter: const Offstage(),
                      labelText: 'No of Children',
                      labelStyle: CustomStyle.blackTextRegular
                          .copyWith(fontSize: 13.sp),
                      suffixIcon: const Icon(Icons.child_care),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.max(50),
                    ]),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    valueTransformer: (val) {
                      if (val != null) {
                        return int.parse(val);
                      }
                    },
                  ),
                  sboxH20,
                  FormBuilderTextField(
                    name: 'mobileNumber',
                    decoration: InputDecoration(
                      counter: const Offstage(),
                      labelText: 'Mobile Number',
                      labelStyle: CustomStyle.blackTextRegular
                          .copyWith(fontSize: 13.sp),
                      suffixIcon: const Icon(Icons.call),
                      prefixIcon: SizedBox(
                        width: 70.w,
                        child: CountryPickerDropdown(
                          itemBuilder: (Country country) => Row(
                            children: <Widget>[
                              CountryPickerUtils.getDefaultFlagImage(country),
                            ],
                          ),
                          initialValue: 'US',
                          itemFilter: (c) => [
                            'AR',
                            'AU',
                            'AT',
                            'BH',
                            'BD',
                            'BE',
                            'BR',
                            'BG',
                            'CA',
                            'CO',
                            'DK',
                            'EG',
                            'FR',
                            'DE',
                            'HK',
                            'IN',
                            'ID',
                            'IR',
                            'IE',
                            'IT',
                            'JP',
                            'KR',
                            'MY',
                            'NP',
                            'NL',
                            'NZ',
                            'NO',
                            'PK',
                            'PH',
                            'PT',
                            'RO',
                            'SG',
                            'ES',
                            'LK',
                            'SE',
                            'TR',
                            'GB',
                            'US',
                            'VN',
                            'CN',
                          ].contains(c.isoCode),
                          //priorityList is shown at the beginning of list
                          priorityList: [
                            CountryPickerUtils.getCountryByIsoCode('GB')!,
                            CountryPickerUtils.getCountryByIsoCode('US')!,
                            CountryPickerUtils.getCountryByIsoCode('CA')!,
                          ],
                          sortComparator: (Country a, Country b) =>
                              a.isoCode.compareTo(b.isoCode),
                          onValuePicked: (Country country) {
                            context
                                .read<CountryCodeUpdateCubit>()
                                .emit(country.phoneCode);
                          },
                        ),
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.minLength(10,
                          errorText: 'Invalid Mobile Number'),
                    ]),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                  ),
                  sboxH20,
                  FormBuilderTextField(
                    name: 'email',
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: CustomStyle.blackTextRegular
                          .copyWith(fontSize: 13.sp),
                      suffixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                      FormBuilderValidators.max(120),
                    ]),
                    keyboardType: TextInputType.text,
                  ),
                  sboxH30,
                  PreferenceBuilder<String>(
                      preference:
                          RepositoryProvider.of<SharedPreferenceMaster>(context)
                              .userProfile,
                      builder: (context, userProfile) {
                        String uId = '';
                        if (userProfile.isNotEmpty) {
                          final profileDetails =
                              jsonDecode(userProfile) as Map<String, dynamic>;
                          uId = profileDetails['userId'];
                          if (uId.isNotEmpty) {}
                        }
                        return const CustomButton(
                                buttonText: CommonStrings.submit)
                            .clickable(
                          () async {
                            if (uId.isNotEmpty) {
                              if (_formKey.currentState != null) {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  final formData = _formKey.currentState!.value;
                                  final code = context
                                      .read<CountryCodeUpdateCubit>()
                                      .state;
                                  final mobileNumber =
                                      '+$code${_formKey.currentState!.value['mobileNumber']}';
                                  final newBooking = BookingRequestModel(
                                    title: widget.packageModel != null
                                        ? widget.packageModel!.title
                                        : '',
                                    destinationId: widget.packageModel != null
                                        ? widget.packageModel!.destinationId
                                        : '',
                                    destinationIds: widget.packageModel != null
                                        ? widget.packageModel!.destinationIds
                                        : [],
                                    duration: widget.packageModel != null
                                        ? widget.packageModel!.duration
                                        : 0,
                                    durationType: widget.packageModel != null
                                        ? widget.packageModel!.durationType
                                        : '',
                                    image: widget.packageModel != null
                                        ? widget.packageModel!.image
                                        : '',
                                    hotelStarRating: context
                                            .read<HotelStarRatingToggleCubit>()
                                            .state
                                            .hotelStarRating ??
                                        '',
                                    fullName: formData['fullName'],
                                    mealPlan: formData['mealPlan'],
                                    tripStartDate: formData['tripStartDate'],
                                    noOfAdults: formData['noOfAdults'],
                                    noOfChildren: formData['noOfChildren'] ?? 0,
                                    mobileNumber: mobileNumber,
                                    email: formData['email'],
                                    userId: uId,
                                  );
                                  context
                                      .read<BookingCubit>()
                                      .createBooking(bookingModel: newBooking);
                                }
                              }
                            } else {
                              await showDialog(
                                context: context,
                                builder: (dContext) {
                                  return CustomCupertinoAlertDialog(
                                    title: 'Alert!',
                                    content: 'Please signup/login to continue',
                                    positiveText: 'Proceed',
                                    negativeText: 'Cancel',
                                    onPositiveActionClick: () {
                                      Navigator.pop(dContext);
                                      Navigator.pushNamed(
                                          context, RouteConstants.routeLogin);
                                    },
                                  );
                                },
                              );
                            }
                          },
                        );
                      }),
                  sboxH30,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

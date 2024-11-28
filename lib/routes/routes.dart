import 'package:asp_asia/module/currency_selection/currency_selection.dart';
import 'package:flutter/material.dart';

import '../common_utils/custom_page_route_builder.dart';
import '../module/tripCustomization/trip_customization.dart';
import '../module/dashboard/dashboard_bottom_nav.dart';
import '../module/login/model/userModel.dart';
import '../module/login/view/login.dart';
import '../module/otp/view/otp_screen.dart';
import '../module/packages/model/package_model.dart';
import '../module/packages/view/package_details.dart';
import '../module/packages/view/package_details_view_more_screen.dart';
import '../module/search/view/package_search.dart';
import '../module/signup/view/signup.dart';
import '../module/splash.dart';
import 'route_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name == RouteConstants.routeSplash) {
    return CustomPageRouteBuilder(
      settings: settings,
      widget: const Splash(),
    );
  }else if (settings.name == RouteConstants.routeCurrencySelection) {
    return CustomPageRouteBuilder(
      settings: settings,
      widget: const CurrencySelection(),
    );
  } else if (settings.name == RouteConstants.routeLogin) {
    return CustomPageRouteBuilder(
      settings: settings,
      widget: Login(),
    );
  } else if (settings.name == RouteConstants.routeSignUp) {
    return CustomPageRouteBuilder(
      settings: settings,
      widget: Signup(),
    );
  } else if (settings.name == RouteConstants.routeOtp) {
    Map<String, dynamic>? data = settings.arguments as Map<String, dynamic>?;
    return CustomPageRouteBuilder(
      settings: settings,
      widget: OtpScreen(
        formData: data,
      ),
    );
  } else if (settings.name == RouteConstants.routeDashboardBottomNav) {
    final UserModel? userModel = settings.arguments as UserModel?;
    return CustomPageRouteBuilder(
      settings: settings,
      widget: DashboardBottomNav(
        userModel: userModel,
      ),
    );
  } else if (settings.name == RouteConstants.routePackageDetails) {
    final PackageModel packageModel = settings.arguments as PackageModel;
    return CustomPageRouteBuilder(
      settings: settings,
      widget: PackageDetails(
        packageModel: packageModel,
      ),
    );
  } else if (settings.name == RouteConstants.routePackageSearch) {
    final packageList = settings.arguments as List<PackageModel>;
    return CustomPageRouteBuilder(
      settings: settings,
      widget: PackageSearch(packagesList: packageList),
    );
  } else if (settings.name == RouteConstants.routePackageDetailsViewMoreScreen) {
    final List<dynamic> data = settings.arguments as List<dynamic>;
    return CustomPageRouteBuilder(
      settings: settings,
      widget: PackageDetailsViewMoreScreen(
        title: data[0],
        overview: data[1],
      ),
    );
  } else if (settings.name == RouteConstants.routeTripCustomization) {
    final packageModel = settings.arguments as PackageModel;
    return CustomPageRouteBuilder(
      settings: settings,
      widget: TripCustomization(
        packageModel: packageModel,
      ),
    );
  } else {
    return CustomPageRouteBuilder(
      settings: settings,
      widget: const Scaffold(
        body: Text('No Route Found'),
      ),
    );
  }
}

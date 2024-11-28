import 'package:asp_asia/module/client_reviews/service/client_reviews_service.dart';
import 'package:asp_asia/module/dashboard/service/recommended_package_api_service.dart';
import 'package:asp_asia/module/expedition/service/expedition_api_service.dart';
import 'package:asp_asia/module/hotels/service/hotel_api_service.dart';
import 'package:asp_asia/module/login/service/login_api_service.dart';
import 'package:asp_asia/module/peakClimbing/service/peak_climbing_api_service.dart';
import 'package:asp_asia/module/signup/service/signup_api_service.dart';
import 'package:asp_asia/services/firebase/firebaseAuth/firebase_auth_service.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'common_utils/common_strings.dart';
import 'common_utils/view_utils/shared_preference_master.dart';
import 'module/adventure/cubit/adventure_cubit.dart';
import 'module/adventure/service/adventure_api_service.dart';
import 'module/client_reviews/bloc/client_reviews_cubit.dart';
import 'module/currency_selection/cubit/currency_selection_cubit.dart';
import 'module/dashboard/cubit/app_bar_toggle_cubit.dart';
import 'module/dashboard/cubit/carousel/carousel_cubit.dart';
import 'module/dashboard/cubit/home_carousel_height_toggle_cubit.dart';
import 'module/dashboard/cubit/home_search_toggle_cubit.dart';
import 'module/dashboard/cubit/packagesByTheme/packages_by_theme_cubit.dart';
import 'module/dashboard/cubit/popularPackages/popular_packages_cubit.dart';
import 'module/dashboard/cubit/recommendedPackages/recommended_package_cubit.dart';
import 'module/dashboard/service/carousel_api_service.dart';
import 'module/dashboard/service/packages_by_theme_api_service.dart';
import 'module/dashboard/service/popular_package_api_service.dart';
import 'module/destinations/bloc/destinations_cubit.dart';
import 'module/destinations/service/destinations_service.dart';
import 'module/expedition/cubit/expedition_cubit.dart';
import 'module/hotels/cubit/hotel_cubit.dart';
import 'module/login/cubit/login_cubit.dart';
import 'module/login/cubit/password_toggle_cubit.dart';
import 'module/login/cubit/username_toggle_cubit.dart';
import 'module/more/bloc/user_cubit.dart';
import 'module/otp/bloc/otp_value_update_cubit.dart';
import 'module/packages/bloc/country_code_update_cubit.dart';
import 'module/packages/bloc/hotel_star_rating_toggle_cubit.dart';
import 'module/packages/bloc/month_of_travel_toggle_cubit.dart';
import 'module/packages/bloc/package_details_top_image_height_toggle_cubit.dart';
import 'module/packages/bloc/package_search_cubit.dart';
import 'module/peakClimbing/cubit/peak_climbing_cubit.dart';
import 'module/search/bloc/search_cubit.dart';
import 'module/search/service/package_search_api_service.dart';
import 'module/signup/bloc/signup_bloc.dart';
import 'module/tour/cubit/tour_cubit.dart';
import 'module/tour/service/tour_api_service.dart';
import 'module/trekking/cubit/trekking_cubit.dart';
import 'module/trekking/service/trekking_api_service.dart';
import 'module/tripCustomization/initial_date_selection_cubit.dart';
import 'module/trips/bloc/booking_cubit.dart';
import 'module/trips/service/booking_api_service.dart';
import 'routes/route_constants.dart';
import 'routes/routes.dart';
import 'services/firebase/firebaseAuth/firebase_otp_service.dart';
import 'services/firebase/firebaseMessaging/firebase_cloud_messaging_service.dart';

class AspirationAsiaApp extends StatefulWidget {
  const AspirationAsiaApp({Key? key, this.sharedPreferences}) : super(key: key);

  final StreamingSharedPreferences? sharedPreferences;

  @override
  State<StatefulWidget> createState() => _AspirationAsiaApp();
}

class _AspirationAsiaApp extends State<AspirationAsiaApp> {
  final FirebaseAuthServices _firebaseAuthServices = FirebaseAuthServices();
  final FirebaseOtpService _firebaseOtpServices = FirebaseOtpService();
  final CarouselApiService _carouselApiService = CarouselApiService();
  final DestinationApiService _destinationApiService = DestinationApiService();
  final TrekkingApiService _trekkingApiService = TrekkingApiService();
  final ExpeditionApiService _expeditionApiService = ExpeditionApiService();
  final PeakClimbingApiService _peakClimbingApiService =
      PeakClimbingApiService();
  final TourApiService _tourApiService = TourApiService();
  final BookingApiService _bookingApiService = BookingApiService();
  final FlutterSecureStorage _flutterSecureStorage =
      const FlutterSecureStorage();
  final FirebaseCloudMessagingServices _firebaseCloudMessagingServices =
      FirebaseCloudMessagingServices();
  final PackagesByThemeApiService _packagesByThemeApiService =
      PackagesByThemeApiService();
  late SharedPreferenceMaster _sharedPreferenceMaster;
  final PopularPackageApiService _popularPackageApiService =
      PopularPackageApiService();
  final RecommendedPackageApiService _recommendedPackageApiService =
      RecommendedPackageApiService();
  final ClientReviewsService _clientReviewsService = ClientReviewsService();
  final HotelsApiService _hotelsApiService = HotelsApiService();
  final AdventureApiService _adventureApiService = AdventureApiService();
  final PackageSearchApiService _packageSearchApiService =
      PackageSearchApiService();
  final LoginApiService _loginApiService = LoginApiService();
  final SignupApiService _signupApiService = SignupApiService();

  @override
  void initState() {
    super.initState();
    _sharedPreferenceMaster = SharedPreferenceMaster(widget.sharedPreferences!);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => OtpValueUpdateCubit(),
        ),
        BlocProvider(
          create: (_) => HomeSearchToggleCubit(),
        ),
        BlocProvider(
          create: (_) => AppBarToggleCubit(),
        ),
        BlocProvider(
          create: (_) => HomeCarouselHeightToggleCubit(),
        ),
        BlocProvider(
          create: (_) => PackageDetailsTopImageHeightToggleCubit(),
        ),
        BlocProvider(
          create: (_) => CarouselCubit(carouselApiService: _carouselApiService),
        ),
        BlocProvider(
          create: (_) => PackagesByThemeCubit(
              packagesByThemeApiService: _packagesByThemeApiService),
        ),
        BlocProvider(
          create: (_) =>
              DestinationsCubit(destinationApiService: _destinationApiService),
        ),
        BlocProvider(
          create: (_) => TrekkingCubit(trekkingApiService: _trekkingApiService),
        ),
        BlocProvider(
          create: (_) =>
              ExpeditionCubit(expeditionApiService: _expeditionApiService),
        ),
        BlocProvider(
          create: (_) => PeakClimbingCubit(
              peakClimbingApiService: _peakClimbingApiService),
        ),
        BlocProvider(
          create: (_) => TourCubit(tourApiService: _tourApiService),
        ),
        BlocProvider(
          create: (_) => HotelStarRatingToggleCubit(),
        ),
        BlocProvider(
          create: (_) => MonthOfTravelToggleCubit(),
        ),
        BlocProvider(
          create: (_) => CountryCodeUpdateCubit(),
        ),
        BlocProvider(
          create: (_) => BookingCubit(bookingApiService: _bookingApiService),
        ),
        BlocProvider(
          create: (_) => PopularPackagesCubit(
              popularPackageApiService: _popularPackageApiService),
        ),
        BlocProvider(
          create: (_) => RecommendedPackageCubit(
              recommendedPackageApiService: _recommendedPackageApiService),
        ),
        BlocProvider(
          create: (_) =>
              ClientReviewsCubit(clientReviewsService: _clientReviewsService),
        ),
        BlocProvider(
          create: (_) => HotelCubit(hotelsApiService: _hotelsApiService),
        ),
        BlocProvider(
          create: (_) =>
              AdventureCubit(adventureApiService: _adventureApiService),
        ),
        BlocProvider(
          create: (_) => PackageSearchCubit(),
        ),
        BlocProvider(
          create: (_) =>
              SearchCubit(packageSearchApiService: _packageSearchApiService),
        ),
        BlocProvider(
          create: (_) => UsernameToggleBloc(),
        ),
        BlocProvider(
          create: (_) => PasswordToggleCubit(),
        ),
        BlocProvider(
          create: (_) => CurrencySelectionCubit(),
        ),
        BlocProvider(
          create: (_) => InitialDateSelectionCubit(),
        ),
        BlocProvider(
          create: (_) => UserCubit(
            sharedPreferences: widget.sharedPreferences,
            loginApiService: _loginApiService,
          ),
        ),
        BlocProvider(
          create: (_) => LoginCubit(
            firebaseCloudMessagingServices: _firebaseCloudMessagingServices,
            flutterSecureStorage: _flutterSecureStorage,
            loginApiService: _loginApiService,
            sharedPreferences: widget.sharedPreferences,
          ),
        ),
        BlocProvider(
          create: (_) => SignUpBloc(
            firebaseCloudMessagingServices: _firebaseCloudMessagingServices,
            flutterSecureStorage: _flutterSecureStorage,
            sharedPreferences: widget.sharedPreferences,
            firebaseAuthServices: _firebaseAuthServices,
            firebaseOtpServices: _firebaseOtpServices,
            signupApiService: _signupApiService,
          ),
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => widget.sharedPreferences!,
          ),
          RepositoryProvider(
            create: (context) => _firebaseAuthServices,
          ),
          RepositoryProvider(
            create: (context) => _sharedPreferenceMaster,
          ),
          RepositoryProvider(
            create: (context) => _flutterSecureStorage,
          ),
          RepositoryProvider(
            create: (context) => _firebaseCloudMessagingServices,
          ),
          RepositoryProvider(
            create: (context) => _bookingApiService,
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(
            375,
            812,
          ),
          splitScreenMode: true,
          minTextAdapt: true,
          builder: (context, widget) => MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: generateRoute,
            initialRoute: RouteConstants.routeSplash,
            theme: ThemeData(
              fontFamily: 'GilroyRegular',
              primarySwatch: Colors.deepOrange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              buttonTheme: ButtonThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            title: CommonStrings.appName,
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:asp_asia/module/dashboard/widgets/home_client_reviews.dart';
import 'package:asp_asia/module/trips/view/trips.dart';
import 'package:asp_asia/routes/route_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../common_utils/custom_sized_box.dart';
import '../../common_utils/view_utils/app_update_remote_config.dart';
import '../../services/firebase/firebaseMessaging/firebase_cloud_messaging_service.dart';
import '../search/view/package_search.dart';
import 'cubit/app_bar_toggle_cubit.dart';
import 'cubit/home_carousel_height_toggle_cubit.dart';
import 'cubit/home_search_toggle_cubit.dart';
import 'cubit/popularPackages/popular_packages_cubit.dart';
import 'widgets/home_destinations_by_theme.dart';
import 'widgets/home_popular_packages.dart';
import 'widgets/home_recommended.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/home_top_rated_hotels.dart';
import 'widgets/home_top_slider.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  return await FirebaseCloudMessagingServices().showBookingNotification(
    message,
    _HomeState().flutterLocalNotificationsPlugin,
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final formKey = GlobalKey<FormBuilderState>();
  final ScrollController scrollController = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool shouldReload = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'aspiration_asia_channel', // id
    'Aspiration Asia Notification', // title
    importance: Importance.high,
  );

  Future selectNotification(NotificationResponse? payload) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: const Trips(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.scale,
    );
  }

  ///Initialize Firebase Push Notifications
  _initFirebasePushNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

  @override
  void initState() {
    _initFirebasePushNotifications();
    super.initState();
    RepositoryProvider.of<FirebaseCloudMessagingServices>(context)
        .initFirebaseMessagingPushNotification(
      context,
      myBackgroundMessageHandler: myBackgroundMessageHandler,
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    try {
      ///Method to check for app's current version and show update dialog if
      ///required
      versionCheck(context);
    } catch (e) {}
    scrollController.addListener(() {
      // print("Scroll value : ${scrollController.offset}");
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (scrollController.offset >= 137.0) {
          context.read<HomeSearchToggleCubit>().emit(false);
        }
        if (scrollController.offset >= 130.0) {
          Timer(
            const Duration(
              milliseconds: 100,
            ),
            () {
              context.read<AppBarToggleCubit>().emit(true);
            },
          );
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (scrollController.offset < 137.0) {
          context.read<HomeSearchToggleCubit>().emit(true);
        }
        if (scrollController.offset < 130.0) {
          Timer(
            const Duration(
              milliseconds: 100,
            ),
            () {
              context.read<AppBarToggleCubit>().emit(false);
            },
          );
        }
        // BlocProvider.of<DashboardHomeSearchBarToggleBloc>(context).add(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ///Pull to refresh feature goes here
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    children: const [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: HomeTopSlider(),
                      )
                    ],
                  ),
                  sboxH50,
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: HomeDestinationsByTheme(),
                  ),
                  sboxH20,
                  const HomePopularPackages(),
                  sboxH20,
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: HomeRecommended(),
                  ),
                  sboxH20,
                  const HomeClientReviews(),
                  sboxH30,
                  const HomeTopRatedHotels(),
                ],
              ),
            ),
            BlocBuilder<HomeSearchToggleCubit, bool>(
              builder: (context, shouldShowSearchBar) {
                return BlocBuilder<HomeCarouselHeightToggleCubit, double>(
                  builder: (context, carouselHeight) {
                    return AnimatedPositioned(
                      top: (shouldShowSearchBar ? carouselHeight - 35.h : -102),
                      duration: const Duration(
                        milliseconds: 600,
                      ),
                      child: SizedBox(
                        height: 70.h,
                        width: MediaQuery.of(context).size.width,
                        //color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          child: const HomeSearchBar().clickable(() {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: PackageSearch(packagesList: const []),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          }),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

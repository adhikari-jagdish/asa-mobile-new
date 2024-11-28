import 'package:flutter/material.dart';

class CustomPageRouteBuilder extends PageRouteBuilder {
  final Widget? widget;

  CustomPageRouteBuilder({
    this.widget,
    required RouteSettings settings,
  }) : super(
            transitionDuration: const Duration(milliseconds: 400),
            settings: settings,
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) {
              animation = CurvedAnimation(parent: animation, curve: Curves.easeOutSine);
              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
            ) {
              return widget!;
            });
}

import 'package:flutter/material.dart';

import '../theme/custom_color.dart';

InputDecoration customDecoration = InputDecoration(
  contentPadding: const EdgeInsets.only(left: 30.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 2.0,
      color: CustomColor.color2a8dc8.withOpacity(0.2),
    ),
    borderRadius: BorderRadius.circular(12.0),
  ),
  border: OutlineInputBorder(
    borderSide: const BorderSide(
      width: 2.0,
      color: CustomColor.color2a8dc8,
    ),
    borderRadius: BorderRadius.circular(12.0),
  ),
);
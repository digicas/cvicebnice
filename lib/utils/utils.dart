import 'dart:math';

import 'package:flutter/material.dart';

/// Returns the relative size based on the ratio to the screen smaller side
double relativeSize(BuildContext context, double ratio) {
  return min(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ) *
      ratio;
}

/// Returns the relative size based on the ratio to the screen smaller side
double relativeWidth(BuildContext context, double ratio) {
  return MediaQuery.of(context).size.width * ratio;
}

ButtonStyle get stadiumButtonStyle => ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color(0xff96365f),
      ),
    );

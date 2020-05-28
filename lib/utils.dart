
import 'dart:math';

import 'package:flutter/material.dart';

/// Returns the relative size based on the ratio to the screen smaller side
double relativeSize(BuildContext context, double ratio) {
  return min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * ratio;
}

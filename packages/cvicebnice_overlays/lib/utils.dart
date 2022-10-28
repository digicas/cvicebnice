import 'package:flutter/material.dart';

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

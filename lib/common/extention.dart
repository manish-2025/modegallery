import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle? display5(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 12.0);
  }
}
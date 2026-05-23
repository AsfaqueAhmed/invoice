import 'package:flutter/material.dart';

/// Reusable EdgeInsets padding constants.
class AppPadding {
  AppPadding._();

  // Symmetric Vertical
  static const EdgeInsets v4 = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets v8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets v12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets v16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets v24 = EdgeInsets.symmetric(vertical: 24);
  static const EdgeInsets v32 = EdgeInsets.symmetric(vertical: 32);

  // Symmetric Horizontal
  static const EdgeInsets h8 = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets h12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets h16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets h20 = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets h24 = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets h32 = EdgeInsets.symmetric(horizontal: 32);

  // Directional
  static const EdgeInsets right8 = EdgeInsets.only(right: 8);

  // All
  static const EdgeInsets all4 = EdgeInsets.all(4);
  static const EdgeInsets all8 = EdgeInsets.all(8);
  static const EdgeInsets all12 = EdgeInsets.all(12);
  static const EdgeInsets all16 = EdgeInsets.all(16);
  static const EdgeInsets all20 = EdgeInsets.all(20);
  static const EdgeInsets all24 = EdgeInsets.all(24);
  static const EdgeInsets all32 = EdgeInsets.all(32);

  // Page / Screen padding
  static const EdgeInsets page =
      EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const EdgeInsets pageLarge =
      EdgeInsets.symmetric(horizontal: 24, vertical: 24);
}

import 'package:flutter/material.dart';

/// Reusable EdgeInsets margin constants.
class AppMargin {
  AppMargin._();

  static const EdgeInsets v4  = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets v8  = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets v12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets v16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets v24 = EdgeInsets.symmetric(vertical: 24);

  static const EdgeInsets h8  = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets h12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets h16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets h24 = EdgeInsets.symmetric(horizontal: 24);

  static const EdgeInsets all4  = EdgeInsets.all(4);
  static const EdgeInsets all8  = EdgeInsets.all(8);
  static const EdgeInsets all12 = EdgeInsets.all(12);
  static const EdgeInsets all16 = EdgeInsets.all(16);
  static const EdgeInsets all24 = EdgeInsets.all(24);

  static const EdgeInsets top8      = EdgeInsets.only(top: 8);
  static const EdgeInsets top16     = EdgeInsets.only(top: 16);
  static const EdgeInsets bottom8   = EdgeInsets.only(bottom: 8);
  static const EdgeInsets bottom16  = EdgeInsets.only(bottom: 16);
  static const EdgeInsets bottom24  = EdgeInsets.only(bottom: 24);
  static const EdgeInsets right12   = EdgeInsets.only(right: 12);
}

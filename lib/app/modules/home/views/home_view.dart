import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.scaffold,
      body: Center(
        child: Text(
          'Home',
          style: TextStyle(color: colors.textPrimary, fontSize: 18),
        ),
      ),
    );
  }
}

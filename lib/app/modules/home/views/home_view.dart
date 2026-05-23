import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/gaps.dart';
import '../../../core/constants/padding.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6_outlined),
            onPressed: () => Get.changeThemeMode(
              Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: AppPadding.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v24,
              Text('Welcome to GetX 👋', style: AppTextStyles.headlineMedium),
              Gaps.v8,
              Text(
                'Your app scaffold is ready. Add your modules inside lib/app/modules.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              Gaps.v40,
              Center(
                child: Column(
                  children: [
                    Text('Counter', style: AppTextStyles.titleMedium),
                    Gaps.v16,
                    Obx(
                      () => Text(
                        '${controller.counter.value}',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Gaps.v24,
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

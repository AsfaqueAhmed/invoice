import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_color.dart';
import '../text_style/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: AppTextStyles.fontFamily,
        brightness: Brightness.light,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColor.primary,
          onPrimary: AppColor.onPrimary,
          primaryContainer: AppColor.primaryFixed,
          onPrimaryContainer: AppColor.onPrimaryFixed,
          secondary: AppColor.secondary,
          onSecondary: AppColor.onSecondary,
          secondaryContainer: AppColor.secondaryContainer,
          onSecondaryContainer: AppColor.onSecondaryContainer,
          tertiary: AppColor.tertiary,
          onTertiary: AppColor.onTertiary,
          tertiaryContainer: AppColor.tertiaryFixed,
          onTertiaryContainer: AppColor.onTertiaryFixed,
          error: AppColor.error,
          onError: AppColor.onError,
          errorContainer: AppColor.errorContainer,
          onErrorContainer: AppColor.onErrorContainer,
          surface: AppColor.surface,
          onSurface: AppColor.onSurface,
          onSurfaceVariant: AppColor.onSurfaceVariant,
          outline: AppColor.outline,
          outlineVariant: AppColor.outlineVariant,
          surfaceContainerLowest: AppColor.surfaceContainerLowest,
          surfaceContainerLow: AppColor.surfaceContainerLow,
          surfaceContainer: AppColor.surfaceContainer,
          surfaceContainerHigh: AppColor.surfaceContainerHigh,
          inverseSurface: AppColor.inverseSurface,
          onInverseSurface: AppColor.inverseOnSurface,
          inversePrimary: AppColor.inversePrimary,
          scrim: Colors.black,
          shadow: Colors.black,
        ),
        scaffoldBackgroundColor: AppColors.scaffoldLight,
        cardColor: AppColors.cardLight,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.surface,
          foregroundColor: AppColor.onSurface,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: AppTextStyles.titleLarge.copyWith(
            color: AppColor.primary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: AppColor.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: AppTextStyles.labelLarge,
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColor.primary,
            side: BorderSide(color: AppColor.outlineVariant),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: AppTextStyles.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.outlineVariant.withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.outlineVariant.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColor.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColor.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColor.error, width: 2),
          ),
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColor.onSurfaceVariant.withOpacity(0.5),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.displayLarge,
          displayMedium: AppTextStyles.displayMedium,
          headlineLarge: AppTextStyles.headlineLarge,
          headlineMedium: AppTextStyles.headlineMedium,
          headlineSmall: AppTextStyles.headlineSmall,
          titleLarge: AppTextStyles.titleLarge,
          titleMedium: AppTextStyles.titleMedium,
          titleSmall: AppTextStyles.titleSmall,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.labelLarge,
          labelMedium: AppTextStyles.labelMedium,
          labelSmall: AppTextStyles.labelSmall,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        fontFamily: AppTextStyles.fontFamily,
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: AppColor.primaryFixedDim,
          onPrimary: AppColor.onPrimaryFixed,
          primaryContainer: AppColor.primaryContainer,
          onPrimaryContainer: AppColor.onPrimaryContainer,
          secondary: AppColor.secondaryFixedDim,
          onSecondary: AppColor.onSecondaryFixed,
          secondaryContainer: AppColor.secondaryContainer,
          onSecondaryContainer: AppColor.onSecondaryContainer,
          tertiary: AppColor.tertiaryFixedDim,
          onTertiary: AppColor.onTertiaryFixed,
          tertiaryContainer: AppColor.tertiaryContainer,
          onTertiaryContainer: AppColor.onTertiaryContainer,
          error: const Color(0xFFF87171),
          onError: AppColor.onError,
          errorContainer: const Color(0xFF7F1D1D),
          onErrorContainer: const Color(0xFFFCA5A5),
          surface: AppColor.darkSurface,
          onSurface: AppColor.darkOnSurface,
          onSurfaceVariant: AppColor.darkOnSurfaceVariant,
          outline: const Color(0xFF6B7280),
          outlineVariant: AppColor.darkOutlineVariant,
          surfaceContainerLowest: AppColor.darkSurfaceContainerLowest,
          surfaceContainerLow: const Color(0xFF1A2233),
          surfaceContainer: AppColor.darkSurfaceContainer,
          surfaceContainerHigh: AppColor.darkSurfaceContainerHigh,
          inverseSurface: AppColor.surface,
          onInverseSurface: AppColor.onSurface,
          inversePrimary: AppColor.primary,
          scrim: Colors.black,
          shadow: Colors.black,
        ),
        scaffoldBackgroundColor: AppColors.scaffoldDark,
        cardColor: AppColors.cardDark,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.darkSurface,
          foregroundColor: AppColor.darkOnSurface,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: AppTextStyles.titleLarge.copyWith(
            color: AppColor.primaryFixedDim,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryFixedDim,
            foregroundColor: AppColor.onPrimaryFixed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: AppTextStyles.labelLarge,
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColor.primaryFixedDim,
            side: BorderSide(color: AppColor.darkOutlineVariant),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: AppTextStyles.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColor.darkSurfaceContainer,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.darkOutlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.darkOutlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColor.primaryFixedDim, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFF87171)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFF87171), width: 2),
          ),
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColor.darkOnSurfaceVariant.withOpacity(0.5),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.displayLarge,
          displayMedium: AppTextStyles.displayMedium,
          headlineLarge: AppTextStyles.headlineLarge,
          headlineMedium: AppTextStyles.headlineMedium,
          headlineSmall: AppTextStyles.headlineSmall,
          titleLarge: AppTextStyles.titleLarge,
          titleMedium: AppTextStyles.titleMedium,
          titleSmall: AppTextStyles.titleSmall,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.labelLarge,
          labelMedium: AppTextStyles.labelMedium,
          labelSmall: AppTextStyles.labelSmall,
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:gatekeep/model/visitor_status.dart';
import 'package:gatekeep/utils/app_colors.dart';
import 'package:gatekeep/utils/app_dimensions.dart';

class AppTheme {
  static Color statusColor(VisitorStatus status) {
    switch (status) {
      case VisitorStatus.registered:
        return AppColors.registered;
      case VisitorStatus.checkedIn:
        return AppColors.checkedIn;
      case VisitorStatus.checkedOut:
        return AppColors.checkedOut;
    }
  }

  static ThemeData light() => build(Brightness.light);

  static ThemeData dark() => build(Brightness.dark);

  static ThemeData build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scaffold = isDark ? AppColors.darkScaffold : AppColors.scaffold;
    final surface = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final text = isDark ? AppColors.textLight : AppColors.textPrimary;

    final colors = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.dark,
      surface: surface,
      onSurface: text,
      outline: border,
      error: AppColors.danger,
    );

    final radius = BorderRadius.circular(AppDimensions.radiusSmall);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colors,
      scaffoldBackgroundColor: scaffold,
      dividerColor: border,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffold,
        foregroundColor: text,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: text),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.dark,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          foregroundColor: text,
          side: BorderSide(color: border),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(surface),
        side: WidgetStatePropertyAll(BorderSide(color: border)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: radius)),
      ),
      chipTheme: ChipThemeData(
        selectedColor: isDark ? AppColors.primaryDark : AppColors.primarySoft,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        showCheckmark: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: isDark ? AppColors.primaryDark : AppColors.primarySoft,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: text)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.dark,
        elevation: 2,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}

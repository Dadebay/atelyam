// ignore_for_file: deprecated_member_use

import 'package:atelyam/app/modules/auth_view/views/auth_view.dart';
import 'package:atelyam/app/modules/settings_view/views/about_us_view.dart';
import 'package:atelyam/app/modules/settings_view/views/all_business_accounts_view.dart';
import 'package:atelyam/app/modules/settings_view/views/favorites_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class Assets {
  static const String noConnection = 'assets/lottie/no_connection.gif';
  static const String loading = 'assets/lottie/loading.json';
  static const String otp_loading = 'assets/lottie/otp_animation.json';
  static const String appName = 'Atelýam';
  static const String logoWhite = 'assets/image/logo_white.png';
  static const String logoBlack = 'assets/image/logo_black.png';
  static const String russianLangIcon = 'assets/image/flags/lang_ru.svg';
  static const String englishLangIcon = 'assets/image/flags/lang_en.svg';
  static const String chinaLangIcon = 'assets/image/flags/lang_ch.svg';
  static const String frenchLangIcon = 'assets/image/flags/lang_fr.svg';
  static const String turkLangIcon = 'assets/image/flags/lang_tr.svg';
  static const String turkmenLangIcon = 'assets/image/flags/lang_tm.svg';
  static const String backgorundPattern1 = 'assets/image/patterns/pattern_1.png';
  static const String backgorundPattern2 = 'assets/image/patterns/pattern_2.png';
  static const String backgorundPattern3 = 'assets/image/patterns/pattern_3.png';
}

final List<Map<String, dynamic>> settingsViews = [
  {
    'name': 'lang',
    'icon': IconlyLight.setting,
    'page': '', // Dil ayarları sayfası
  },
  {
    'name': 'favorites',
    'icon': IconlyLight.heart,
    'page': () => FavoritesView(), // Favoriler sayfası
  },
  {
    'name': 'aboutUs',
    'icon': IconlyLight.info_square,
    'page': () => AboutUsView(), // Hakkında sayfası
  },
  {
    'name': 'login',
    'icon': IconlyLight.login,
    'page': () => AuthView(), // Giriş sayfası
  },
];
final List<Map<String, dynamic>> loggedInSettingsViews = [
  {
    'name': 'business_accounts_profil',
    'icon': IconlyLight.user,
    'page': () => AllBusinessAccountsView(), // Dil ayarları sayfası
  },
  {
    'name': 'lang',
    'icon': IconlyLight.setting,
    'page': '', // Dil ayarları sayfası
  },
  {
    'name': 'favorites',
    'icon': IconlyLight.heart,
    'page': () => FavoritesView(), // Favoriler sayfası
  },
  {
    'name': 'aboutUs',
    'icon': IconlyLight.info_square,
    'page': () => AboutUsView(), // Hakkında sayfası
  },
  {
    'name': 'login',
    'icon': IconlyLight.login,
    'page': () => AuthView(), // Giriş sayfası
  },
];

class Fonts {
  static const String plusJakartaSans = 'PlusJakartaSans';
}

class BorderRadii {
  static const BorderRadius borderRadius5 = BorderRadius.all(Radius.circular(5));
  static const BorderRadius borderRadius10 = BorderRadius.all(Radius.circular(10));
  static const BorderRadius borderRadius15 = BorderRadius.all(Radius.circular(15));
  static const BorderRadius borderRadius18 = BorderRadius.all(Radius.circular(18));
  static const BorderRadius borderRadius20 = BorderRadius.all(Radius.circular(20));
  static const BorderRadius borderRadius25 = BorderRadius.all(Radius.circular(25));
  static const BorderRadius borderRadius30 = BorderRadius.all(Radius.circular(30));
  static const BorderRadius borderRadius35 = BorderRadius.all(Radius.circular(35));
  static const BorderRadius borderRadius40 = BorderRadius.all(Radius.circular(40));
  static const BorderRadius borderRadius50 = BorderRadius.all(Radius.circular(50));
  static const BorderRadius borderRadius88 = BorderRadius.all(Radius.circular(88));
  static const BorderRadius borderRadius99 = BorderRadius.all(Radius.circular(99));
}

class AppColors {
  static const Color kPrimaryColor = Color(0xff092104);
  static const Color kSecondaryColor = Color(0xff234d1e);
  static const Color kThirdColor = Color(0xffb6f1a7);
  static const Color darkMainColor = Color(0xFF111218);
  static const Color whiteMainColor = Color(0xFFFDFEFF);
  static const Color warmWhiteColor = Color(0xFFFFEEDA);
  static const Color greenColor = Color(0xFF05B124);
  static const Color redColor = Color(0xFFE95861);
}

class AppFontSizes {
  static double getFontSize(double baseSize) {
    return screenWidth * baseSize / 100;
  }

  static double get screenWidth => Get.width;
  static double get screenHeight => Get.height;
  static double get fontSize12 => screenWidth * 0.031;
  static double get fontSize14 => screenWidth * 0.036;
  static double get fontSize16 => screenWidth * 0.041;
  static double get fontSize20 => screenWidth * 0.052; // Yeni: Font Size 20
  static double get fontSize24 => screenWidth * 0.0625;
  static double get fontSize30 => screenWidth * 0.078; // Yeni: Font Size 30
  static double get fontSize35 => screenWidth * 0.091; // Yeni: Font Size 35
  static double get fontSize44 => screenWidth * 0.11;
  static double get fontSize52 => screenWidth * 0.1354;
}

class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: Fonts.plusJakartaSans,
      colorSchemeSeed: AppColors.darkMainColor,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkMainColor,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.darkMainColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, systemNavigationBarColor: AppColors.kPrimaryColor),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: Fonts.plusJakartaSans,
          fontSize: 20,
        ),
        elevation: 0,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent.withOpacity(0),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

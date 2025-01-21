// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Assets {
  static const String noConnection = 'assets/lottie/noconnection.json';
  static const String loading = 'assets/lottie/loadingNew.json';
  static const String otp_loading = 'assets/lottie/otp_lottie.json';
  static const String otp_loading2 = 'assets/lottie/otpp.json';
  static const String more = 'assets/icons/more.svg';
  static const String appName = 'Atelyam';
  static const String logoWhite = 'assets/image/logo_white.png';
  static const String logoBlack = 'assets/image/logo_black.png';
  static const String share = 'assets/icons/share1.svg';
  static const String settingsLang = 'assets/icons/lang_icon.svg';
  static const String settingsAboutUs = 'assets/icons/about_us_icon.svg';
  static const String settingsContactUs = 'assets/icons/contact_us_icon.svg';
  static const String languageChina = 'assets/icons/lang_china.svg';
  static const String languageEnglish = 'assets/icons/lang_eng.svg';
  static const String languageFrench = 'assets/icons/lang_french.svg';
  static const String languageGerman = 'assets/icons/lang_german.svg';
  static const String selectedLangIcon = 'assets/icons/selected_lang.svg';
  static const String unselectedLangIcon = 'assets/icons/unselected_lang.svg';
  static const String backgorundPattern1 = 'assets/image/patterns/patterns_2.png';
  static const String backgorundPattern = 'assets/image/patterns/patterns_2.png';
  static const String loremImpsum =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Why do we use it?It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).";
}

class LanguageIcons {
  static const String russianLangIcon = 'assets/image/flags/lang_ru.svg';
  static const String englishLangIcon = 'assets/image/flags/lang_en.svg';
  static const String chinaLangIcon = 'assets/image/flags/lang_ch.svg';
  static const String frenchLangIcon = 'assets/image/flags/lang_fr.svg';
  static const String turkLangIcon = 'assets/image/flags/lang_tr.svg';
  static const String turkmenLangIcon = 'assets/image/flags/lang_tm.svg';
}

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
  static const Color buttonsBackColor = Color(0xff171920);
  static const Color darkSecondaryColor = Color(0xFF1D1E27);
  static const Color darkSecondaryButtonColor = Color(0xFF171920);
  static const Color whiteMainColor = Color(0xFFFDFEFF);
  static const Color white1Color = Color(0xFFAFAFAF);
  static const Color warmWhiteColor = Color(0xFFFFEEDA);
  static const Color textColorMain = Color(0xFF474747);
  static const Color secondaryTextColor = Color(0xFF707070);
  static const Color strokeColor = Color(0xFF2A2A2F);
  static const Color mainButtonGradientStart = Color(0xFFFEA845);
  static const Color mainButtonGradientEnd = Color(0xFFA1E87E);
  static const Color brandYellow = Color(0xFFFEA845);
  static const Color brandYellow1 = Color(0xFFFEA445);
  static const Color systemGreenGraph = Color(0xFF05B124);
  static const Color systemRedGraph = Color(0xFFD21B1E);
  static const Color errorRed = Color(0xFF7A0007);
  static const Color red1Color = Color(0xFFE95861);
  static const Color green = Color(0xFF05B124);
  static const Color languageBlueColor = Color(0xFF05B124);
}

class GradientsColors {
  static LinearGradient brandYellowGradient = LinearGradient(
    begin: Alignment.center,
    end: Alignment.topCenter,
    stops: const [0.4, 1.0],
    colors: [
      AppColors.darkMainColor.withOpacity(0.2),
      AppColors.brandYellow.withOpacity(0.6),
    ],
  );
}

class AppFontSizes {
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

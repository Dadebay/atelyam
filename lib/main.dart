import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/modules/auth_view/views/connection_check_view.dart';
import 'package:atelyam/app/utils/utils.dart';
import 'package:atelyam/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GetStorage storage = GetStorage();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Atelyam',
      theme: AppThemes.lightTheme,
      fallbackLocale: const Locale('tr'), // Fallback locale
      locale: _getLocale(), // Set locale based on storage
      translations: MyTranslations(), // Your translations
      defaultTransition: Transition.fadeIn, // Default transition
      home: ConnectionCheckView(), // Initial screen
    );
  }

  // Helper method to get locale from storage
  Locale _getLocale() {
    final String? langCode = storage.read('langCode');
    if (langCode != null) {
      return Locale(langCode);
    } else {
      return const Locale('tm'); // Default locale
    }
  }
}

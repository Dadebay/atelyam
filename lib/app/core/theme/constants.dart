import 'package:atelyam/app/modules/auth_view/views/auth_view.dart';
import 'package:atelyam/app/modules/settings_view/views/about_us_view.dart';
import 'package:atelyam/app/modules/settings_view/views/all_business_accounts.dart';
import 'package:atelyam/app/modules/settings_view/views/create_product.view.dart';
import 'package:atelyam/app/modules/settings_view/views/favorites_view.dart';
import 'package:iconly/iconly.dart';

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
    'name': 'business_accounts',
    'icon': IconlyLight.add_user,
    'page': () => AllBusinessAccountsView(), // Dil ayarları sayfası
  },
  {
    'name': 'add_product',
    'icon': IconlyLight.paper_plus,
    'page': () => UploadProductView(), // Dil ayarları sayfası
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

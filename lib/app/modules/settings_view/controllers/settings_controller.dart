import 'dart:developer';
import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/dialogs.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class NewSettingsPageController extends GetxController {
  RxInt selectedAvatarIndex = 0.obs;
  final Rx<Map<String, dynamic>?> selectedCategory =
      Rx<Map<String, dynamic>?>(null);
  final Rx<Map<String, dynamic>?> selectedBusinessCategory =
      Rx<Map<String, dynamic>?>(null);
  final Rx<Map<String, dynamic>?> selectedHasTag =
      Rx<Map<String, dynamic>?>(null);
  final ImagePicker _picker = ImagePicker();
  var selectedImage = Rx<File?>(null);

  final _box = GetStorage();
  final Dialogs dialogs = Dialogs();
  RxBool isLoginView = false.obs;
  final RxList<ProductModel> favoriteProducts = <ProductModel>[].obs;

  // User data
  final RxString username = ''.obs;
  final RxString phoneNumber = ''.obs;

  final List<Map<String, String>> appLanguages = [
    {'name': 'Türkmen', 'code': 'tm', 'icon': LanguageIcons.turkmenLangIcon},
    {'name': 'Русский', 'code': 'ru', 'icon': LanguageIcons.russianLangIcon},
    {'name': 'English', 'code': 'en', 'icon': LanguageIcons.englishLangIcon},
    {'name': 'Türkçe', 'code': 'tr', 'icon': LanguageIcons.turkLangIcon},
    {'name': '中文', 'code': 'ch', 'icon': LanguageIcons.chinaLangIcon},
  ];

  @override
  void onInit() {
    super.onInit();

    loadSelectedAvatar();
    loadFavoriteProducts();
    loadUserData(); // Load user data when the controller initializes
  }

  final List<String> avatars =
      List.generate(12, (index) => 'assets/icons/user${index + 1}.png');

  Future<void> saveSelectedAvatar(int index) async {
    selectedAvatarIndex.value = index;
    await _box.write('selectedAvatar', index);
  }

  Future<void> loadSelectedAvatar() async {
    final int? index = _box.read('selectedAvatar');
    if (index != null) {
      selectedAvatarIndex.value = index;
    }
  }

  void showLanguageDialog(BuildContext context) {
    dialogs.showLanguageDialog();
  }

  void loadFavoriteProducts() {
    final List<dynamic>? storedFavorites = _box.read('favoriteProducts');
    if (storedFavorites != null) {
      favoriteProducts.value =
          storedFavorites.map((json) => ProductModel.fromJson(json)).toList();
    }
  }

  void _saveFavoriteProducts() {
    final List<Map<String, dynamic>> favoritesJson =
        favoriteProducts.map((product) => product.toJson()).toList();
    _box.write('favoriteProducts', favoritesJson);
  }

  // Toggle favorite product
  void toggleFavoriteProduct(ProductModel product) {
    if (favoriteProducts.any((p) => p.id == product.id)) {
      favoriteProducts.removeWhere((p) => p.id == product.id); // Remove product
    } else {
      favoriteProducts.add(product); // Add product
    }
    _saveFavoriteProducts(); // Save changes
  }

  void clearFavorites() {
    favoriteProducts.clear(); // Clear the list
    _box.remove('favoriteProducts'); // Remove favorite products from GetStorage
  }

  bool isProductFavorite(ProductModel product) {
    return favoriteProducts.any((p) => p.id == product.id);
  }

  Future<void> logout() async {
    await _box.remove('token'); // Remove token
    isLoginView.value = false; // Update login status
  }

  // Save user data (username and phone number)
  Future<void> saveUserData(String newUsername, String newPhoneNumber) async {
    username.value = newUsername;
    phoneNumber.value = newPhoneNumber;
    await _box.write('username', newUsername);
    await _box.write('phoneNumber', newPhoneNumber);
  }

  // Load user data (username and phone number)
  void loadUserData() {
    final String? storedUsername = _box.read('username');
    final String? storedPhoneNumber = _box.read('phoneNumber');
    if (storedUsername != null) {
      username.value = storedUsername;
    }
    if (storedPhoneNumber != null) {
      phoneNumber.value = storedPhoneNumber;
    }
  }

  // Clear user data (username and phone number)
  Future<void> clearUserData() async {
    username.value = '';
    phoneNumber.value = '';
    await _box.remove('username');
    await _box.remove('phoneNumber');
  }

  //selecting title id
  void selectingCategory({value}) {
    selectedCategory.value = value;
    log(selectedCategory.value.toString());
  }

  //selecting busCategory id
  void selectingBusinessCategory({value}) {
    selectedBusinessCategory.value = value;
    log(selectedBusinessCategory.value.toString());
  }

  //selecting hashtag id
  void selectingHashtag({value}) {
    selectedHasTag.value = value;
    log(selectedBusinessCategory.value.toString());
  }

  //  to pick multiple images
  Future<void> pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  //  to remove the selected image
  void removeImage() {
    selectedImage.value = null;
  }
}

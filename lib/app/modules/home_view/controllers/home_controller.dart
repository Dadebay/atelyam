import 'package:atelyam/app/data/models/banner_model.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/banner_service.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:atelyam/app/data/service/hashtag_service.dart';
import 'package:atelyam/app/modules/category_view/views/category_view.dart';
import 'package:atelyam/app/modules/discovery_view/views/discovery_view.dart';
import 'package:atelyam/app/modules/home_view/views/home_view.dart';
import 'package:atelyam/app/modules/settings_view/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool agreeButton = false.obs;
  final List<Widget> pages = [
    HomeView(),
    CategoryView(),
    DiscoveryView(),
    // Container(),
    SettingsView(),
  ];

  final BannerService _bannerService = BannerService();
  final BusinessCategoryService _categoryService = BusinessCategoryService();
  final HashtagService _hashtagService = HashtagService();

  late Rx<Future<List<BannerModel>>> bannersFuture;
  late Rx<Future<List<BusinessCategoryModel>?>> categoriesFuture;
  late Rx<Future<List<HashtagModel>>> hashtagsFuture; // Hashtag verileri
  RxMap<int, Future<List<ProductModel>>> productsFutures = <int, Future<List<ProductModel>>>{}.obs; // Ürünlerin verileri
  RxInt carouselSelectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchBanners();
    _fetchCategories();
    _fetchHashtags();
  }

  Future<void> _fetchBanners() async {
    bannersFuture = _bannerService.fetchBanners().obs;
  }

  Future<void> _fetchCategories() async {
    categoriesFuture = _categoryService.fetchCategories().obs;
  }

  Future<void> _fetchHashtags() async {
    hashtagsFuture = _hashtagService.fetchHashtags().obs;
  }

  Future<List<ProductModel>> fetchProductsByHashtagId(int hashtagId) async {
    return _hashtagService.fetchProductsByHashtagId(hashtagId);
  }

  Future<void> refreshBanners() async {
    await _fetchBanners();
    await _fetchCategories();
    await _fetchHashtags();
  }

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void updateCarouselIndex(int index) {
    carouselSelectedIndex.value = index;
  }
}

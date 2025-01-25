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
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum FilterOption {
  lowPrice,
  highPrice,
  viewCount,
  first,
  last,
}

class HomeController extends GetxController {
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxBool isLoadingProducts = false.obs;
  RxString activeFilter = 'last'.obs; // Varsayılan filtre
  RxInt currentPage = 1.obs;
  final RefreshController refreshController = RefreshController();

  // Ürünleri başlat
  void initializeProducts(int hashtagId) {
    isLoadingProducts.value = true;

    allProducts.clear();
    currentPage.value = 1;
    loadProducts(hashtagId);
  }

  // Ürünleri yükle
  Future<void> loadProducts(int hashtagId) async {
    try {
      final products = await HashtagService().fetchProductsByHashtagId(
        hashtagId: hashtagId,
        page: currentPage.value,
        size: 10, // Sabit sayfa boyutu
        filter: activeFilter.value,
      );

      if (products.isNotEmpty) {
        allProducts.addAll(products);
      }
      print(currentPage);
      print(allProducts.length);
    } catch (e) {
      Get.snackbar('error'.tr, 'Failed to load products: $e', colorText: Colors.red);
    } finally {
      isLoadingProducts.value = false;

      refreshController.loadComplete();
    }
  }

  // Yenileme işlemi
  Future<void> refreshProducts(
    int hashtagId,
  ) async {
    isLoadingProducts.value = true;

    currentPage.value = 1;
    allProducts.clear();
    await loadProducts(hashtagId);
    refreshController.refreshCompleted();
  }

  // Daha fazla ürün yükleme işlemi
  Future<void> loadMoreProducts(int hashtagId) async {
    currentPage.value++;

    await loadProducts(hashtagId);
    refreshController.loadComplete();
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  RxInt selectedIndex = 0.obs;
  RxBool agreeButton = false.obs;
  final List<Widget> pages = [
    HomeView(),
    CategoryView(),
    DiscoveryView(),
    // Container(),
    SettingsView(),
  ];
  RxBool isFilterExpanded = false.obs; // Yeni değişken
  Rx<FilterOption?> selectedFilter = Rx<FilterOption?>(FilterOption.last); // Seçilen filtre

  void toggleFilterExpanded() {
    isFilterExpanded.toggle(); // Filtre durumunu tersine çevir
  }

  void setSelectedFilter(FilterOption? value) {
    selectedFilter.value = value; // Seçilen filtreyi güncelle
  }

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
    return _hashtagService.fetchProductsByHashtagId(hashtagId: hashtagId);
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

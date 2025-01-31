import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/banner_model.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/banner_service.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:atelyam/app/data/service/hashtag_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController {
  RxString activeFilter = 'last'.obs; // Varsayılan filtre
  RxBool agreeButton = false.obs;
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  late Rx<Future<List<BannerModel>>> bannersFuture;
  RxInt carouselSelectedIndex = 0.obs;
  late Rx<Future<List<BusinessCategoryModel>?>> categoriesFuture;
  RxInt currentPage = 1.obs;
  late Rx<Future<List<HashtagModel>>> hashtagsFuture; // Hashtag verileri
  RxBool isFilterExpanded = false.obs; // Yeni değişken
  RxBool isLoadingProducts = false.obs;
  RxMap<int, Future<List<ProductModel>>> productsFutures = <int, Future<List<ProductModel>>>{}.obs; // Ürünlerin verileri
  final RefreshController refreshController = RefreshController();
  Rx<FilterOption?> selectedFilter = Rx<FilterOption?>(FilterOption.last); // Seçilen filtre
  RxInt selectedIndex = 0.obs;
  final BannerService _bannerService = BannerService();
  final BusinessCategoryService _categoryService = BusinessCategoryService();
  final HashtagService _hashtagService = HashtagService();

  @override
  void onInit() {
    super.onInit();
    _fetchBanners();
    _fetchCategories();
    _fetchHashtags();
  }

  // Ürünleri başlat
  void initializeProducts(int hashtagId) {
    isLoadingProducts.value = true;
    activeFilter = 'last'.obs;
    selectedFilter.value = FilterOption.last;
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
    } catch (e) {
      showSnackBar('Hata', 'Bir hata oluştu: $e', AppColors.redColor); // Hata mesajı göster
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

  Future<List<ProductModel>> fetchProductsByHashtagId(int hashtagId) async {
    return _hashtagService.fetchProductsByHashtagId(hashtagId: hashtagId);
  }

  Future<void> refreshBanners() async {
    await _fetchBanners();
    await _fetchCategories();
    await _fetchHashtags();
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
}

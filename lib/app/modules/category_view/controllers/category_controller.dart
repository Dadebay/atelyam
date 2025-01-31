import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/hashtag_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoryController extends GetxController {
  RxBool value = false.obs;
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxBool isLoadingProducts = false.obs;
  RxString activeFilter = 'last'.obs; // Varsayılan filtre
  RxInt currentPage = 1.obs;
  final RefreshController refreshController = RefreshController();
  RxBool isFilterExpanded = false.obs; // Yeni değişken
  Rx<FilterOption?> selectedFilter = Rx<FilterOption?>(FilterOption.last);

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      value.value = true;
    });
  }

  void toggleFilterExpanded() {
    isFilterExpanded.toggle(); // Filtre durumunu tersine çevir
  }

  void setSelectedFilter(FilterOption? value) {
    selectedFilter.value = value; // Seçilen filtreyi güncelle
  }

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
    } catch (e) {
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
}

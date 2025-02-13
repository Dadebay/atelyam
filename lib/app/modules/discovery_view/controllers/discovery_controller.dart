import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/product_service.dart';
import 'package:atelyam/app/product/custom_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscoveryController extends GetxController {
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final List<ProductModel> products = <ProductModel>[].obs;
  int page = 1;
  final int size = 10;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1; // Sayfayı sıfırla
      hasMore = true; // Daha fazla veri olduğunu varsay
      products.clear(); // Listeyi temizle
      refreshController.resetNoData(); // RefreshController'ı sıfırla
    }

    if (!hasMore) {
      refreshController.loadNoData(); // Daha fazla veri yoksa RefreshController'ı güncelle
      return;
    }

    try {
      final newProducts = await ProductService().fetchPopularProducts(page: page, size: size);
      if (newProducts != null && newProducts.isNotEmpty) {
        products.addAll(newProducts); // Yeni ürünleri listeye ekle
        page++; // Sayfayı artır
      } else {
        hasMore = false; // Daha fazla veri yok
        refreshController.loadNoData(); // RefreshController'ı güncelle
      }
    } catch (e) {
      showSnackBar('networkError'.tr, 'noInternet'.tr, Colors.red);
    } finally {
      if (isRefresh) {
        refreshController.refreshCompleted(); // Yenileme işlemi tamamlandı
      } else {
        refreshController.loadComplete(); // Yükleme işlemi tamamlandı
      }
    }
  }

  void onRefresh() => fetchProducts(isRefresh: true); // Yenileme işlemi
  void onLoading() => fetchProducts(); // Yükleme işlemi
}
